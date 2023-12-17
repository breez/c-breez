package com.cBreez.client

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.cBreez.client.Constants.NOTIFICATION_ID_PAYMENT_RECEIVED
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class BreezNotificationService {
    companion object {
        private const val TAG = "BreezNotificationService"

        fun createNotification(
            applicationContext: Context,
            contentText: String?,
            notificationID: Int = System.currentTimeMillis().toInt() / 1000,
            importance: Int = NotificationManager.IMPORTANCE_DEFAULT,
            setOngoing: Boolean = false
        ): Notification {
            val channelId =
                applicationContext.getString(R.string.offline_payments_notification_channel_id)
            val channelName =
                applicationContext.getString(R.string.offline_payments_notification_channel_name)
            val channelDesc =
                applicationContext.getString(R.string.offline_payments_notification_channel_description)

            val notificationIcon = R.mipmap.ic_stat_ic_notification
            val notificationColor = applicationContext.getColor(R.color.breez_notification_color)

            val notification =
                NotificationCompat.Builder(applicationContext, channelId)
                    .setSmallIcon(notificationIcon)
                    .setColor(notificationColor)
                    .setContentText(contentText)
                    .setAutoCancel(true) // Required for notification to persist after work is complete
                    .setOngoing(setOngoing) // Required for notification to persist after work is complete
                    .build()

            val notificationManager =
                applicationContext.getSystemService(Context.NOTIFICATION_SERVICE)
                        as NotificationManager

            if (notificationManager.areNotificationsEnabled()) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val mChannel = NotificationChannel(channelId, channelName, importance)
                    mChannel.description = channelDesc
                    // Register the channel with the system. You can't change the importance
                    // or other notification behaviors after this.
                    if (notificationManager.getNotificationChannel(channelId) == null) {
                        notificationManager.createNotificationChannel(mChannel)
                    }
                }
                // Required for notification to persist after work is complete
                CoroutineScope(Dispatchers.Main).launch {
                    delay(200)
                    // Dismiss generic information notification
                    if (notificationID != NOTIFICATION_ID_PAYMENT_RECEIVED) {
                        notificationManager.cancel(NOTIFICATION_ID_PAYMENT_RECEIVED)
                        Log.i(TAG, "Dismissed status notification")
                    }
                    notificationManager.notify(
                        notificationID,
                        notification
                    )
                }

            }
            return notification
        }
    }
}