package com.cBreez.client

import android.app.Service
import android.content.Intent
import android.os.Binder
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import androidx.annotation.RequiresApi
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import breez_sdk.BlockingBreezServices
import breez_sdk.BreezEvent
import breez_sdk.EventListener
import breez_sdk.PaymentStatus
import com.cBreez.client.BreezNotificationHelper.Companion.dismissForegroundServiceNotification
import com.cBreez.client.BreezNotificationHelper.Companion.notifyForegroundService
import com.cBreez.client.BreezNotificationHelper.Companion.notifyPaymentFailed
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
import kotlinx.coroutines.withContext
import org.tinylog.kotlin.Logger
import java.util.concurrent.locks.ReentrantLock

class BreezForegroundService : Service() {
    companion object {
        private const val TAG = "BreezForegroundService"
    }

    inner class BreezNodeBinder : Binder() {
        fun getService(): BreezForegroundService = this@BreezForegroundService
    }

    // SDK events listener
    inner class SDKListener : EventListener {
        override fun onEvent(e: BreezEvent) {
            Logger.tag(TAG).info { "Received event $e" }
            if (e is BreezEvent.InvoicePaid) {
                val pD = e.details
                Logger.tag(TAG).info {
                    "Received payment. Bolt11:${pD.bolt11}\nPayment Hash:${pD.paymentHash}"
                }
                val amountSat = (e.details.payment?.amountMsat ?: ULong.MIN_VALUE) / 1000u
                if (!paymentReceivedInBackground.contains(e.details.paymentHash)) {
                    paymentReceivedInBackground.add(e.details.paymentHash)
                    notifyPaymentReceived(applicationContext, amountSat = amountSat)
                }

                // push back shutdown by 120s in case we'll receive more payments
                shutdownHandler.removeCallbacksAndMessages(null)
                shutdownHandler.postDelayed(shutdownRunnable, 120 * 1000L)
            }
        }
    }

    private var breezSDK: BlockingBreezServices? = null
    private val serviceScope = CoroutineScope(Dispatchers.Main.immediate + SupervisorJob())
    private val binder = BreezNodeBinder()

    /**
     * State of the wallet, provides access to the business when started. Private so that it's not
     * mutated from the outside.
     */
    private val _state = MutableLiveData<NodeServiceState>(NodeServiceState.Off)
    val state: LiveData<NodeServiceState>
        get() = _state

    /** Lock for state updates */
    private val stateLock = ReentrantLock()

    /** List of payments received while the app is in the background */
    private val paymentReceivedInBackground = mutableListOf<String>()

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
        paymentReceivedInBackground.clear()
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
        if (paymentReceivedInBackground.isEmpty()) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        } else {
            stopForeground(STOP_FOREGROUND_DETACH)
        }
        shutdown()
    }

    /** Shutdown the node, close connections and stop the service */
    private fun shutdown() {
        Logger.tag(TAG).info { "Shutting down Breez node service" }
        stopSelf()
        _state.postValue(NodeServiceState.Off)
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
                val clickAction = it.data["click_action"]
                paymentHash?.let {
                    startBusiness(paymentHash, clickAction)
                }
            }
        }

        shutdownHandler.removeCallbacksAndMessages(null)
        shutdownHandler.postDelayed(shutdownRunnable, 120 * 1000L) // push back shutdown by 120s
        return START_NOT_STICKY
    }

    private fun startBusiness(
        paymentHash: String,
        clickAction: String?,
    ) {
        val notification = notifyForegroundService(applicationContext)
        when {
            breezSDK != null && _state.value is NodeServiceState.Running -> {
                // NOTE: the notification will NOT be shown if the app is already running
                startForeground(NOTIFICATION_ID_FOREGROUND_SERVICE, notification)
                serviceScope.launch(
                    Dispatchers.IO +
                            CoroutineExceptionHandler { _, e ->
                                Logger.tag(TAG).error { "Error when polling payment: $e" }
                                notifyPaymentFailed(applicationContext)
                            }
                ) {
                    Logger.tag(TAG)
                        .info { "Using current running node service to poll payment" }
                    pollPaymentHash(paymentHash, clickAction)
                }
            }

            else -> {
                startForeground(NOTIFICATION_ID_FOREGROUND_SERVICE, notification)
                Logger.tag(TAG).debug { "Starting wallet..." }
                stateLock.lock()
                if (_state.value != NodeServiceState.Off) {
                    Logger.tag(TAG).warn {
                        "ignore attempt to start business in state=${_state.value}"
                    }
                    return
                } else {
                    _state.postValue(NodeServiceState.Init)
                }
                stateLock.unlock()
                serviceScope.launch(
                    Dispatchers.IO +
                            CoroutineExceptionHandler { _, e ->
                                Logger.tag(TAG).error { "Error when starting node: $e" }
                                _state.postValue(NodeServiceState.Error(e))
                                shutdown()
                                stopForeground(STOP_FOREGROUND_REMOVE)
                            }
                ) {
                    Logger.tag(TAG).info {
                        "Starting node from service state=${_state.value?.name}"
                    }
                    breezSDK = connectSDK(applicationContext, SDKListener())
                    pollPaymentHash(paymentHash, clickAction)
                    _state.postValue(NodeServiceState.Running)
                }
            }
        }
    }

    private suspend fun pollPaymentHash(
        paymentHash: String,
        clickAction: String?,
    ) {
        // Poll for 1 minute
        for (i in 1..60) {
            val payment = breezSDK!!.paymentByHash(paymentHash)
            if (payment?.status == PaymentStatus.COMPLETE) {
                if (!paymentReceivedInBackground.contains(paymentHash)) {
                    paymentReceivedInBackground.add(paymentHash)
                    notifyPaymentReceived(
                        applicationContext,
                        clickAction,
                        amountSat = payment.amountMsat / 1000u
                    )
                }
                return
            } else {
                Logger.tag(TAG).info { "Payment w/ paymentHash: $paymentHash not received yet." }
                withContext(Dispatchers.IO) { Thread.sleep(1_000) }
            }
        }

        // If we reach here then we didn't receive for more than 1 minute
        throw Exception("Payment not found before timeout")
    }

    private fun Intent?.getRemoteMessage(): RemoteMessage? {
        @Suppress("DEPRECATION")
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            this?.getParcelableExtra("remote_message", RemoteMessage::class.java)
        else this?.getParcelableExtra("remote_message")
    }
}