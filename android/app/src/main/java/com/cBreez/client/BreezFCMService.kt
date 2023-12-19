package com.cBreez.client

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.app.KeyguardManager
import android.os.Process
import android.os.SystemClock
import com.google.android.gms.common.util.PlatformVersion.isAtLeastLollipop
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import org.tinylog.kotlin.Logger

@SuppressLint("MissingFirebaseInstanceTokenRefresh")
class BreezFcmService : FirebaseMessagingService() {
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        // Only handle remote messages if app is in the background
        if (isAppForeground()) {
            Logger.info { "App is in the foreground." }
            return
        }

        Logger.debug { "From: ${remoteMessage.from}" }
        // Check if message contains a data payload.
        if (remoteMessage.data.isNotEmpty()) {
            Logger.debug { "Message data payload: ${remoteMessage.data}" }
            handleNow(remoteMessage)
        }
    }

    private fun handleNow(remoteMessage: RemoteMessage): Boolean {
        return if (remoteMessage.data["notification_type"] == "payment_received") {
            val paymentHash = remoteMessage.data["payment_hash"]
            paymentHash?.let {
                JobManager.instance.startPaymentReceivedJob(applicationContext, paymentHash)
            }
            true
        } else {
            false
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