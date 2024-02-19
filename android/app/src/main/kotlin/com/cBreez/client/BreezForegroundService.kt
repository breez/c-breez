package com.cBreez.client

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import androidx.core.content.IntentCompat
import breez_sdk.BlockingBreezServices
import breez_sdk.LogEntry
import com.breez.breez_sdk.SdkLogInitializer
import com.cBreez.client.BreezNotificationHelper.Companion.notifyForegroundService
import com.cBreez.client.BreezNotificationHelper.Companion.registerNotificationChannels
import com.cBreez.client.BreezSdkConnector.Companion.connectSDK
import com.cBreez.client.Constants.EXTRA_REMOTE_MESSAGE
import com.cBreez.client.Constants.NOTIFICATION_ID_FOREGROUND_SERVICE
import com.cBreez.client.Constants.SHUTDOWN_DELAY_MS
import com.cBreez.client.job.LnurlPayInfoJob
import com.cBreez.client.job.LnurlPayInvoiceJob
import com.cBreez.client.job.ReceivePaymentJob
import com.cBreez.client.job.SDKJob
import com.google.firebase.messaging.RemoteMessage
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import org.tinylog.kotlin.Logger

interface ForegroundService {
    fun pushbackShutdown()
    fun shutdown()
}

class BreezForegroundService : ForegroundService, Service() {
    private var breezSDK: BlockingBreezServices? = null
    private val serviceScope = CoroutineScope(Dispatchers.Main.immediate + SupervisorJob())

    companion object {
        private const val TAG = "BreezForegroundService"
    }

    override fun onCreate() {
        super.onCreate()
        Logger.tag(TAG).debug { "Creating Breez foreground service..." }
        registerNotificationChannels(applicationContext)
        val sdkLogListener = SdkLogInitializer.initializeNodeLogStream()
        sdkLogListener.subscribe(serviceScope) { l: LogEntry ->
            when (l.level) {
                "ERROR" -> Logger.tag(TAG).error { l.line }
                "WARN" -> Logger.tag(TAG).warn { l.line }
                "INFO" -> Logger.tag(TAG).info { l.line }
                "DEBUG" -> Logger.tag(TAG).debug { l.line }
                "TRACE" -> Logger.tag(TAG).trace { l.line }
            }
        }
        Logger.tag(TAG).debug { "Breez foreground service created." }
    }

    // =========================================================== //
    //                      SERVICE LIFECYCLE                      //
    // =========================================================== //

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    /** Stop the service */
    private val shutdownHandler = Handler(Looper.getMainLooper())
    private val shutdownRunnable: Runnable = Runnable {
        Logger.tag(TAG).debug { "Reached scheduled shutdown..." }
        shutdown()
    }

    override fun pushbackShutdown() {
        shutdownHandler.removeCallbacksAndMessages(null)
        shutdownHandler.postDelayed(shutdownRunnable, SHUTDOWN_DELAY_MS)
    }

    override fun shutdown() {
        Logger.tag(TAG).debug { "Shutting down Breez foreground service" }
        SdkLogInitializer.unsubscribeNodeLogStream(serviceScope)
        stopForeground(STOP_FOREGROUND_REMOVE)
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

        // Display foreground service notification when connecting for the first time
        val notification = notifyForegroundService(applicationContext)
        startForeground(NOTIFICATION_ID_FOREGROUND_SERVICE, notification)

        // Connect to SDK if source intent has data message with valid payload
        getJobFromNotification(intent)?.also {
            launchSdkConnection(it)
        } ?: run {
            Logger.tag(TAG).warn { "Received invalid data message." }
            shutdown()
        }

        return START_NOT_STICKY
    }

    private fun getJobFromNotification(intent: Intent?): SDKJob? {
        return intent?.remoteMessage?.let { rm ->
            rm.notificationPayload?.let { payload ->
                when (rm.notificationType) {
                    "payment_received" -> ReceivePaymentJob(applicationContext, this, payload)
                    "lnurlpay_info" -> LnurlPayInfoJob(applicationContext, this, payload)
                    "lnurlpay_invoice" -> LnurlPayInvoiceJob(applicationContext, this, payload)
                    else -> null
                }
            }
        }
    }

    private fun launchSdkConnection(job: SDKJob) {
        serviceScope.launch(Dispatchers.IO + CoroutineExceptionHandler { _, e ->
            Logger.tag(TAG).error { "Breez SDK connection failed $e" }
            shutdown()
        }) {
            breezSDK ?: run {
                breezSDK = connectSDK(applicationContext, job)
            }

            breezSDK?.let {
                job.start(breezSDK!!)

                // Push back shutdown by SHUTDOWN_DELAY_MS
                pushbackShutdown()
            }
        }
    }

    /* Remote Message helper properties */
    private val Intent?.remoteMessage: RemoteMessage?
        get() {
            @Suppress("DEPRECATION")
            return this?.let {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
                    IntentCompat.getParcelableExtra(
                        it,
                        EXTRA_REMOTE_MESSAGE,
                        RemoteMessage::class.java
                    )
                else it.getParcelableExtra(EXTRA_REMOTE_MESSAGE)
            }
        }

    private val RemoteMessage.notificationType: String?
        get() {
            return data["notification_type"]?.takeUnless { it.isEmpty() }
        }

    private val RemoteMessage.notificationPayload: String?
        get() {
            return data["notification_payload"]
        }
}