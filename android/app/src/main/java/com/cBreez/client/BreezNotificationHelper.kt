package com.cBreez.client

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationChannelGroup
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.cBreez.client.Constants.NOTIFICATION_CHANNEL_FOREGROUND_SERVICE
import com.cBreez.client.Constants.NOTIFICATION_CHANNEL_PAYMENT_RECEIVED
import com.cBreez.client.Constants.NOTIFICATION_ID_FOREGROUND_SERVICE
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.tinylog.kotlin.Logger

class BreezNotificationHelper {

    companion object {
        private const val TAG = "BreezNotificationService"

        @RequiresApi(Build.VERSION_CODES.O)
        fun registerNotificationChannels(context: Context) {
            val notificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE)
                        as NotificationManager
            if (notificationManager.areNotificationsEnabled()) {
                createNotificationChannelGroup(context, notificationManager)
                createNotificationChannels(context, notificationManager)
            }
        }

        @RequiresApi(Build.VERSION_CODES.O)
        private fun createNotificationChannels(
            context: Context,
            notificationManager: NotificationManager,
        ) {
            val foregroundServiceNotificationChannel = NotificationChannel(
                NOTIFICATION_CHANNEL_FOREGROUND_SERVICE,
                context.getString(R.string.foreground_service_notification_channel_name),
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description =
                    context.getString(R.string.foreground_service_notification_channel_description)
            }
            val workGroupId = context.getString(R.string.offline_payments_work_group_id)
            val receivedPaymentsNotificationChannel = NotificationChannel(
                NOTIFICATION_CHANNEL_PAYMENT_RECEIVED,
                context.getString(R.string.payment_received_notification_channel_name),
                NotificationManager.IMPORTANCE_DEFAULT
            ).apply {
                description =
                    context.getString(R.string.payment_received_notification_channel_description)
                group = workGroupId
            }
            notificationManager.createNotificationChannels(
                listOf(
                    foregroundServiceNotificationChannel,
                    receivedPaymentsNotificationChannel
                )
            )
        }

        @RequiresApi(Build.VERSION_CODES.O)
        private fun createNotificationChannelGroup(
            context: Context,
            notificationManager: NotificationManager,
        ) {
            val offlinePaymentsNotificationChannelGroup = NotificationChannelGroup(
                context.getString(R.string.offline_payments_work_group_id),
                context.getString(R.string.offline_payments_work_group_name),
            )
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                offlinePaymentsNotificationChannelGroup.description =
                    context.getString(R.string.offline_payments_work_group_description)
            }

            notificationManager.createNotificationChannelGroup(
                offlinePaymentsNotificationChannelGroup
            )
        }

        fun notifyForegroundService(context: Context): Notification {
            val notificationColor = context.getColor(R.color.breez_notification_color)

            return NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_FOREGROUND_SERVICE)
                .apply {
                    setContentTitle(context.getString(R.string.foreground_service_notification_title))
                    setSmallIcon(R.mipmap.ic_stat_ic_notification)
                    setColorized(true)
                    setOngoing(true)
                    color = notificationColor
                }.build().also {
                    if (ActivityCompat.checkSelfPermission(
                            context,
                            Manifest.permission.POST_NOTIFICATIONS
                        ) == PackageManager.PERMISSION_GRANTED
                    ) {
                        NotificationManagerCompat.from(context)
                            .notify(NOTIFICATION_ID_FOREGROUND_SERVICE, it)
                    }
                }
        }

        fun dismissForegroundServiceNotification(context: Context) {
            // Dismiss generic information notification
            NotificationManagerCompat.from(context).cancel(NOTIFICATION_ID_FOREGROUND_SERVICE)
            Logger.tag(TAG).debug { "Dismissed status notification" }
        }

        fun notifyPaymentReceived(
            context: Context,
            clickAction: String? = "FLUTTER_NOTIFICATION_CLICK",
            amountSat: ULong,
        ): Notification {
            val notificationID: Int = System.currentTimeMillis().toInt() / 1000
            val notificationColor = context.getColor(R.color.breez_notification_color)

            val notificationIntent = Intent(clickAction)
            notificationIntent.putExtra("click_action", clickAction)

            val flags =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE else PendingIntent.FLAG_UPDATE_CURRENT
            val approvePendingIntent = PendingIntent.getActivity(
                context,
                0,
                notificationIntent,
                flags
            )

            val buttonTitle = "Open"
            val notificationAction = NotificationCompat.Action.Builder(
                android.R.drawable.ic_delete,
                buttonTitle,
                approvePendingIntent
            ).build()

            return NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_PAYMENT_RECEIVED)
                .apply {
                    setContentTitle(context.getString(R.string.payment_received_notification_title))
                    setContentText("Received $amountSat sats")
                    setSmallIcon(R.mipmap.ic_stat_ic_notification)
                    setContentIntent(approvePendingIntent)
                    addAction(notificationAction)
                    setLights(notificationColor, 1000, 300)
                    // Dismiss on click
                    setOngoing(false)
                    setAutoCancel(true)
                }.build().also {
                    if (ActivityCompat.checkSelfPermission(
                            context,
                            Manifest.permission.POST_NOTIFICATIONS
                        ) == PackageManager.PERMISSION_GRANTED
                    ) {
                        // Required for notification to persist after work is complete
                        CoroutineScope(Dispatchers.Main).launch {
                            delay(200)
                            if (ActivityCompat.checkSelfPermission(
                                    context,
                                    Manifest.permission.POST_NOTIFICATIONS
                                ) == PackageManager.PERMISSION_GRANTED
                            ) {
                                // Use notificationID
                                NotificationManagerCompat.from(context)
                                    .notify(notificationID, it)
                            }

                        }

                    }
                }
        }
    }
}