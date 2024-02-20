package com.cBreez.client

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.app.KeyguardManager
import android.content.Intent
import android.os.Process
import android.os.SystemClock
import androidx.core.content.ContextCompat
import breez_sdk_notification.LogHelper.Companion.configureLogger
import breez_sdk_notification.Constants
import com.google.android.gms.common.util.PlatformVersion
import com.google.android.gms.common.util.PlatformVersion.isAtLeastLollipop
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import org.tinylog.kotlin.Logger

@SuppressLint("MissingFirebaseInstanceTokenRefresh")
class BreezFcmService : FirebaseMessagingService() {
    companion object {
        private const val TAG = "BreezFcmService"
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)

        configureLogger(applicationContext)
        Logger.tag(TAG).debug { "FCM notification received!" }
        startServiceIfNeeded(remoteMessage)
    }

    /** Check if message is a data payload w/ high priority
     * as we cannot start foreground service from low/normal priority message */
    private fun startServiceIfNeeded(remoteMessage: RemoteMessage) {
        with(remoteMessage) {
            Logger.tag(TAG).debug { "From: $from" }
            val isServiceNeeded = when (data[Constants.NOTIFICATION_DATA_TYPE]) {
                Constants.NOTIFICATION_TYPE_PAYMENT_RECEIVED -> !isAppForeground()
                else -> true
            }
            if (data.isNotEmpty() && isServiceNeeded && priority == RemoteMessage.PRIORITY_HIGH) startBreezForegroundService()
            else Logger.tag(TAG).warn { "Ignoring FCM message $data" }
        }
    }

    private fun RemoteMessage.startBreezForegroundService() {
        Logger.tag(TAG).debug { "Starting BreezForegroundService w/ remote message $data" }
        val intent = Intent(applicationContext, BreezForegroundService::class.java)
        intent.putExtra(Constants.EXTRA_REMOTE_MESSAGE, this)
        ContextCompat.startForegroundService(applicationContext, intent)
    }

    @SuppressLint("VisibleForTests")
    private fun isAppForeground(): Boolean {
        val keyguardManager = getSystemService(KEYGUARD_SERVICE) as KeyguardManager
        if (keyguardManager.isKeyguardLocked) {
            return false // Screen is off or lock screen is showing
        }
        // Screen is on and unlocked, now check if the process is in the foreground
        if (!isAtLeastLollipop()) {
            // Before L the process has IMPORTANCE_FOREGROUND while it executes BroadcastReceivers.
            // As soon as the service is started the BroadcastReceiver should stop.
            // UNFORTUNATELY the system might not have had the time to downgrade the process
            // (this is happening consistently in JellyBean).
            // With SystemClock.sleep(10) we tell the system to give a little bit more of CPU
            // to the main thread (this code is executing on a secondary thread) allowing the
            // BroadcastReceiver to exit the onReceive() method and downgrade the process priority.
            SystemClock.sleep(10)
        }
        val pid = Process.myPid()
        val am = getSystemService(ACTIVITY_SERVICE) as ActivityManager
        val appProcesses = am.runningAppProcesses
        if (appProcesses != null) {
            for (process in appProcesses) {
                if (process.pid == pid) {
                    return process.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND
                }
            }
        }
        return false
    }
}