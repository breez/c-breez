package com.cBreez.client

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import com.cBreez.client.Constants.NOTIFICATION_ID_PAYMENT_RECEIVED
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.tinylog.kotlin.Logger

class BreezNotificationService {
    companion object {
        private const val TAG = "BreezNotificationService"

        fun createNotification(
            applicationContext: Context,
            contentText: String?,
            notificationID: Int = System.currentTimeMillis().toInt() / 1000,
            importance: Int = NotificationManager.IMPORTANCE_DEFAULT,
            setOngoing: Boolean = false,
            clickAction: String? = null,
        ): Notification {
            val channelId =
                applicationContext.getString(R.string.offline_payments_notification_channel_id)
            val channelName =
                applicationContext.getString(R.string.offline_payments_notification_channel_name)
            val channelDesc =
                applicationContext.getString(R.string.offline_payments_notification_channel_description)

            val notificationIcon = R.mipmap.ic_stat_ic_notification
            val notificationColor = applicationContext.getColor(R.color.breez_notification_color)
            val contentTitle = if (clickAction != null) "Payment Received!" else null
            val notificationIntent: Intent = Intent(clickAction)
            notificationIntent.putExtra("click_action", clickAction)

            val flags =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE else PendingIntent.FLAG_UPDATE_CURRENT
            val approvePendingIntent = PendingIntent.getActivity(
                applicationContext,
                0,
                notificationIntent,
                flags
            )

            val buttonTitle = "Open"
            val action = NotificationCompat.Action.Builder(
                android.R.drawable.ic_delete,
                buttonTitle,
                approvePendingIntent
            ).build()
            val notificationAction = if (clickAction != null) action else null

            val notification =
                NotificationCompat.Builder(applicationContext, channelId)
                    .setSmallIcon(notificationIcon)
                    .setColorized(true)
                    .setColor(notificationColor)
                    .setLights(notificationColor, 1000, 300)
                    .setContentTitle(contentTitle)
                    .setContentText(contentText)
                    .setOngoing(setOngoing) // Required for notification to persist after work is complete
                    .setContentIntent(approvePendingIntent)
                    .addAction(notificationAction)
                    .setPriority(2)
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
                        Logger.tag(TAG).debug { "Dismissed status notification" }
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