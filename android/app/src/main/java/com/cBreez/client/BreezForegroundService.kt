package com.cBreez.client

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import breez_sdk.BlockingBreezServices
import breez_sdk.BreezEvent
import breez_sdk.EventListener
import breez_sdk.Payment
import com.cBreez.client.BreezNotificationHelper.Companion.notifyForegroundService
import com.cBreez.client.BreezNotificationHelper.Companion.notifyPaymentReceived
import com.cBreez.client.BreezNotificationHelper.Companion.registerNotificationChannels
import com.cBreez.client.BreezSdkConnector.Companion.connectSDK
import com.cBreez.client.BreezSdkConnector.Companion.disconnectSDK
import com.cBreez.client.Constants.EXTRA_REMOTE_MESSAGE
import com.cBreez.client.Constants.NOTIFICATION_ID_FOREGROUND_SERVICE
import com.google.firebase.messaging.RemoteMessage
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import org.tinylog.kotlin.Logger

class BreezForegroundService : Service() {
    private var breezSDK: BlockingBreezServices? = null
    private val serviceScope = CoroutineScope(Dispatchers.Main.immediate + SupervisorJob())
    private var receivedPayment: Payment? = null

    companion object {
        private const val TAG = "BreezForegroundService"
        private const val SHUTDOWN_DELAY_MS = 60 * 1000L // 60 seconds
    }

    // SDK events listener
    inner class SDKListener : EventListener {
        override fun onEvent(e: BreezEvent) {
            Logger.tag(TAG).trace { "Received event $e" }
            when (e) {
                is BreezEvent.InvoicePaid -> {
                    val pd = e.details
                    handleReceivedPayment(pd.bolt11, pd.paymentHash, pd.payment?.amountMsat)
                    receivedPayment = pd.payment

                    // Push back shutdown by SHUTDOWN_DELAY_MS for payments synced event
                    pushbackShutdown()
                }

                is BreezEvent.Synced -> {
                    receivedPayment?.let {
                        Logger.tag(TAG).info { "Got synced event for received payment." }
                        shutdown()
                    }
                }

                else -> {}
            }
        }

        private fun handleReceivedPayment(
            bolt11: String,
            paymentHash: String,
            amountMsat: ULong?,
        ) {
            Logger.tag(TAG)
                .info { "Received payment. Bolt11:${bolt11}\nPayment Hash:${paymentHash}" }
            val amountSat = (amountMsat ?: ULong.MIN_VALUE) / 1000u
            notifyPaymentReceived(applicationContext, amountSat = amountSat)
        }
    }

    override fun onCreate() {
        super.onCreate()
        Logger.tag(TAG).debug { "Creating Breez foreground service..." }
        registerNotificationChannels(applicationContext)
        Logger.tag(TAG).debug { "Breez foreground service created." }
    }

    // =========================================================== //
    //                      SERVICE LIFECYCLE                      //
    // =========================================================== //

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    private val shutdownHandler = Handler(Looper.getMainLooper())
    private val shutdownRunnable: Runnable = Runnable {
        Logger.tag(TAG).debug { "Reached scheduled shutdown..." }
        shutdown()
    }

    /** Stop the service */
    private fun shutdown() {
        Logger.tag(TAG).debug { "Shutting down Breez foreground service" }
        stopForeground(STOP_FOREGROUND_REMOVE)
        disconnectSDK()
        stopSelf()
    }

    // =========================================================== //
    //                    START COMMAND HANDLER                    //
    // =========================================================== //

    /** Called when an intent is called for this service. */
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)
        val intentDetails = "[ intent=$intent, flag=$flags, startId=$startId ]"
        Logger.tag(TAG).debug { "Start Breez foreground service from intent $intentDetails" }

        // Connect to SDK if source intent has data message with valid payload
        intent?.remoteMessage.run {
            if (this != null && isPaymentReceived && !paymentHash.isNullOrBlank()) {
                launchSdkConnection()
            } else {
                Logger.tag(TAG).warn { "Received invalid data message." }
                shutdown()
            }
        }

        return START_NOT_STICKY
    }

    private fun launchSdkConnection() {
        serviceScope.launch(Dispatchers.IO + CoroutineExceptionHandler { _, e ->
            Logger.tag(TAG).error { "Breez SDK connection failed $e" }
            shutdown()
        }) {
            breezSDK ?: run {
                // Display foreground service notification when connecting for the first time
                val notification = notifyForegroundService(applicationContext)
                startForeground(NOTIFICATION_ID_FOREGROUND_SERVICE, notification)

                breezSDK = connectSDK(applicationContext, SDKListener())

                // Push back shutdown by SHUTDOWN_DELAY_MS
                pushbackShutdown()
            }
        }
    }

    private fun pushbackShutdown() {
        shutdownHandler.removeCallbacksAndMessages(null)
        shutdownHandler.postDelayed(shutdownRunnable, SHUTDOWN_DELAY_MS)
    }

    /* Remote Message helper properties */
    private val Intent?.remoteMessage: RemoteMessage?
        get() {
            @Suppress("DEPRECATION")
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
                this?.getParcelableExtra(EXTRA_REMOTE_MESSAGE, RemoteMessage::class.java)
            else this?.getParcelableExtra(EXTRA_REMOTE_MESSAGE)
        }

    private val RemoteMessage.isPaymentReceived: Boolean
        get() {
            return data["notification_type"] == "payment_received"
        }

    private val RemoteMessage.paymentHash: String?
        get() {
            return data["payment_hash"]
        }
}