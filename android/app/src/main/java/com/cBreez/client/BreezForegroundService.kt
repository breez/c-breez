package com.cBreez.client

import android.app.Service
import android.content.Intent
import android.os.Binder
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import androidx.annotation.RequiresApi
import breez_sdk.BlockingBreezServices
import breez_sdk.BreezEvent
import breez_sdk.EventListener
import breez_sdk.LogEntry
import breez_sdk.LogStream
import breez_sdk.setLogStream
import com.cBreez.client.BreezNotificationHelper.Companion.dismissForegroundServiceNotification
import com.cBreez.client.BreezNotificationHelper.Companion.notifyForegroundService
import com.cBreez.client.BreezNotificationHelper.Companion.notifyPaymentReceived
import com.cBreez.client.BreezNotificationHelper.Companion.registerNotificationChannels
import com.cBreez.client.BreezSdkConnector.Companion.connectSDK
import com.cBreez.client.Constants.NOTIFICATION_ID_FOREGROUND_SERVICE
import com.google.firebase.messaging.RemoteMessage
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import org.tinylog.kotlin.Logger

class BreezForegroundService : Service() {
    companion object {
        private const val TAG = "BreezForegroundService"
        private const val SHUTDOWN_DELAY_MS = 120 * 1000L // 120 seconds
    }

    inner class BreezNodeBinder : Binder() {
        fun getService(): BreezForegroundService = this@BreezForegroundService
    }

    // SDK events listener
    inner class SDKListener : EventListener {
        override fun onEvent(e: BreezEvent) {
            Logger.tag(TAG).info { "Received event $e" }
            if (e is BreezEvent.InvoicePaid) {
                val pd = e.details
                handleReceivedPayment(pd.bolt11, pd.paymentHash, pd.payment?.amountMsat)
            }
        }
    }

    internal class SDKLogListener : LogStream {
        override fun log(l: LogEntry) {
            if (l.level != "TRACE") {
                Logger.tag("Greenlight").debug { "[${l.level}] ${l.line}" }
            }
        }
    }

    private var breezSDK: BlockingBreezServices? = null
    private val serviceScope = CoroutineScope(Dispatchers.Main.immediate + SupervisorJob())
    private val binder = BreezNodeBinder()

    override fun onCreate() {
        super.onCreate()
        Logger.tag(TAG).debug { "Creating Breez node service..." }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            registerNotificationChannels(applicationContext)
        }
        Logger.tag(TAG).debug { "Breez node service created." }
    }

    // =========================================================== //
    //                      SERVICE LIFECYCLE                      //
    // =========================================================== //

    override fun onBind(intent: Intent?): IBinder {
        Logger.tag(TAG).debug { "Binding Breez node service from intent=$intent" }
        stopForeground(STOP_FOREGROUND_REMOVE)
        dismissForegroundServiceNotification(applicationContext)
        return binder
    }

    override fun onUnbind(intent: Intent?): Boolean {
        return false
    }

    private val shutdownHandler = Handler(Looper.getMainLooper())
    private val shutdownRunnable: Runnable = Runnable {
        Logger.tag(TAG).debug { "Reached scheduled shutdown..." }
        stopForeground(STOP_FOREGROUND_DETACH)
        shutdown()
    }

    /** Shutdown the node, close connections and stop the service */
    private fun shutdown() {
        Logger.tag(TAG).info { "Shutting down Breez node service" }
        stopSelf()
    }

    // =========================================================== //
    //                    START COMMAND HANDLER                    //
    // =========================================================== //

    /** Called when an intent is called for this service. */
    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)
        Logger.tag(TAG).debug {
            "Start Breez node service from intent [ intent=$intent, flag=$flags, startId=$startId ]"
        }
        intent.getRemoteMessage()?.let {
            if (it.data["notification_type"] == "payment_received") {
                val paymentHash = it.data["payment_hash"]
                paymentHash?.let {
                    serviceScope.launch(
                        Dispatchers.IO +
                                CoroutineExceptionHandler { _, e ->
                                    Logger.tag(TAG).error { "Breez SDK connection failed $e" }
                                    shutdown()
                                    stopForeground(STOP_FOREGROUND_REMOVE)
                                }
                    ) {
                        if (breezSDK == null) {
                            // Display foreground service notification when connecting for the first time
                            val notification = notifyForegroundService(applicationContext)
                            startForeground(NOTIFICATION_ID_FOREGROUND_SERVICE, notification)

                            // Connect to the SDK
                            Logger.tag(TAG).info { "Breez SDK is not connected, connecting...." }
                            breezSDK = connectSDK(applicationContext, SDKListener())
                            Logger.tag(TAG).info { "Breez SDK connected successfully" }
                        }
                    }
                }
            }
        }

        // Push back shutdown by SHUTDOWN_DELAY_MS after connecting to the SDK
        shutdownHandler.removeCallbacksAndMessages(null)
        shutdownHandler.postDelayed(shutdownRunnable, SHUTDOWN_DELAY_MS)
        return START_NOT_STICKY
    }

    private fun handleReceivedPayment(
        bolt11: String,
        paymentHash: String,
        amountMsat: ULong?,
        clickAction: String? = null,
    ) {
        Logger.tag(TAG).info {
            "Received payment. Bolt11:${bolt11}\nPayment Hash:${paymentHash}"
        }
        val amountSat = (amountMsat ?: ULong.MIN_VALUE) / 1000u
        notifyPaymentReceived(applicationContext, clickAction = clickAction, amountSat = amountSat)

        // Push back shutdown by SHUTDOWN_DELAY_MS in case we'll receive more payments
        shutdownHandler.removeCallbacksAndMessages(null)
        shutdownHandler.postDelayed(shutdownRunnable, SHUTDOWN_DELAY_MS)
    }

    private fun Intent?.getRemoteMessage(): RemoteMessage? {
        @Suppress("DEPRECATION")
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            this?.getParcelableExtra("remote_message", RemoteMessage::class.java)
        else this?.getParcelableExtra("remote_message")
    }
}