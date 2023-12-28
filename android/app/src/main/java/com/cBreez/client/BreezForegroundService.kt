package com.cBreez.client

import android.app.Service
import android.content.Intent
import android.os.Binder
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.Parcelable
import androidx.annotation.RequiresApi
import com.cBreez.client.BreezNotificationService.Companion.dismissForegroundServiceNotification
import com.cBreez.client.BreezNotificationService.Companion.notifyForegroundService
import com.cBreez.client.BreezNotificationService.Companion.registerNotificationChannels
import com.cBreez.client.Constants.NOTIFICATION_ID_FOREGROUND_SERVICE
import com.google.firebase.messaging.RemoteMessage
import org.tinylog.kotlin.Logger

class BreezForegroundService : Service() {
    companion object {
        private const val TAG = "BreezForegroundService"
    }

    inner class BreezNodeBinder : Binder() {
        fun getService(): BreezForegroundService = this@BreezForegroundService
    }

    private val binder = BreezNodeBinder()

    /** True if the service is running headless (that is without a GUI). In that case we should show a notification */
    @Volatile
    private var isHeadless = true

    override fun onCreate() {
        super.onCreate()
        Logger.tag(TAG).debug("Creating Breez node service...")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            registerNotificationChannels(applicationContext)
        }
        startForeground(
            NOTIFICATION_ID_FOREGROUND_SERVICE,
            notifyForegroundService(applicationContext)
        )
        Logger.tag(TAG).debug("Breez node service created.")
    }

    // =========================================================== //
    //                      SERVICE LIFECYCLE                      //
    // =========================================================== //

    override fun onBind(intent: Intent?): IBinder {
        Logger.tag(TAG).debug("Binding Breez node service from intent=$intent")
        // UI is binding to the service. The service is not headless anymore and we can remove the notification.
        isHeadless = false
        stopForeground(STOP_FOREGROUND_REMOVE)
        dismissForegroundServiceNotification(applicationContext)
        return binder
    }

    /** When unbound, the service is running headless. */
    override fun onUnbind(intent: Intent?): Boolean {
        isHeadless = true
        return false
    }

    private val shutdownHandler = Handler(Looper.getMainLooper())
    private val shutdownRunnable: Runnable = Runnable {
        if (isHeadless) {
            Logger.tag(TAG).debug("Reached scheduled shutdown...")
            stopForeground(STOP_FOREGROUND_DETACH)
            shutdown()
        }
    }

    /** Shutdown the node, close connections and stop the service */
    private fun shutdown() {
        Logger.tag(TAG).info("Shutting down Breez node service")
        stopSelf()
    }

    // =========================================================== //
    //                    START COMMAND HANDLER                    //
    // =========================================================== //

    /** Called when an intent is called for this service. */
    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)
        Logger.tag(TAG)
            .debug("Start Breez node service from intent [ intent=$intent, flag=$flags, startId=$startId ]")
        startForeground(
            NOTIFICATION_ID_FOREGROUND_SERVICE,
            notifyForegroundService(applicationContext)
        )
        getParcelable(
            intent, "remote_message",
            RemoteMessage::class.java
        )?.let { handleNow(it) }

        shutdownHandler.removeCallbacksAndMessages(null)
        shutdownHandler.postDelayed(shutdownRunnable, 60 * 1000L) // push back shutdown by 60s
        if (!isHeadless) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        }
        return START_NOT_STICKY
    }

    private fun handleNow(remoteMessage: RemoteMessage): Boolean {
        return if (remoteMessage.data["notification_type"] == "payment_received") {
            val paymentHash = remoteMessage.data["payment_hash"]
            val clickAction = remoteMessage.data["click_action"]
            paymentHash?.let {
                JobManager.instance.startPaymentReceivedJob(
                    applicationContext,
                    paymentHash,
                    clickAction
                )
            }
            true
        } else {
            false
        }
    }

    private fun <T : Parcelable?> getParcelable(
        intent: Intent?,
        name: String,
        clazz: Class<T>,
    ): T? {
        @Suppress("DEPRECATION")
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            intent?.getParcelableExtra(name, clazz)
        else
            intent?.getParcelableExtra(name) as T?
    }
}