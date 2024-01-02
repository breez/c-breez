package com.cBreez.client

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.app.KeyguardManager
import android.content.Intent
import android.os.Process
import android.os.SystemClock
import androidx.core.content.ContextCompat
import com.cBreez.client.BreezLogger.Companion.configureLogger
import com.cBreez.client.Constants.EXTRA_REMOTE_MESSAGE
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
        Logger.tag(TAG).info { "FCM notification received!" }
        // Only handle remote messages if app is in the background
        if (isAppForeground()) {
            Logger.tag(TAG).info { "App is in the foreground." }
            return
        }

        // Start service if data message is received
        startService(remoteMessage)
    }

    private fun startService(remoteMessage: RemoteMessage) {
        Logger.tag(TAG).debug { "From: ${remoteMessage.from}" }
        // Check if message contains a data payload.
        var payload = remoteMessage.data
        if (payload.isNotEmpty()) {
            Logger.tag(TAG).debug { "Message data payload: $payload" }
            // Cannot start foreground service from low/normal priority message
            if (remoteMessage.priority != RemoteMessage.PRIORITY_HIGH) {
                Logger.tag(TAG).warn { "Ignoring FCM message with low/normal priority" }
            } else {
                Logger.tag(TAG).debug { "Start BreezForegroundService w/ remote message $payload" }
                val intent = Intent(applicationContext, BreezForegroundService::class.java)
                intent.putExtra(EXTRA_REMOTE_MESSAGE, remoteMessage)
                ContextCompat.startForegroundService(applicationContext, intent)
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