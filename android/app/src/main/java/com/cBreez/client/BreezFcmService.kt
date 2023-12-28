package com.cBreez.client

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.app.KeyguardManager
import android.content.Intent
import android.os.Process
import android.os.SystemClock
import androidx.core.content.ContextCompat
import com.cBreez.client.BreezLogger.Companion.configureLogger
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
        // Only handle remote messages if app is in the background
        if (isAppForeground()) {
            Logger.tag(TAG).info { "App is in the foreground." }
            return
        }

        Logger.tag(TAG).debug { "From: ${remoteMessage.from}" }
        // Check if message contains a data payload.
        if (remoteMessage.data.isNotEmpty()) {
            Logger.tag(TAG).debug { "Message data payload: ${remoteMessage.data}" }
            // cannot start foreground service from low/normal priority message
            if (remoteMessage.priority != RemoteMessage.PRIORITY_HIGH) {
                Logger.tag(TAG).warn { "Ignoring FCM message with low/normal priority" }
            } else {
                Logger.tag(TAG)
                    .debug { "Starting BreezForegroundService with remote message ${remoteMessage.data}" }
                val serviceIntent =
                    Intent(applicationContext, BreezForegroundService::class.java)
                serviceIntent.putExtra("remote_message", remoteMessage)
                ContextCompat.startForegroundService(applicationContext, serviceIntent)
            }
        }
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