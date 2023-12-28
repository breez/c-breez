package com.cBreez.client

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.cBreez.client.Constants.HEADLESS_NOTIF_CHANNEL
import com.cBreez.client.Constants.NOTIFICATION_ID_FOREGROUND_SERVICE

object SystemNotificationHelper {
    fun registerNotificationChannels(context: Context) {
        // notification channels (android 8+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId =
                context.getString(R.string.offline_payments_notification_channel_id)
            val channelName =
                context.getString(R.string.offline_payments_notification_channel_name)
            val channelDesc =
                context.getString(R.string.offline_payments_notification_channel_description)
            context.getSystemService(NotificationManager::class.java)?.createNotificationChannels(
                listOf(
                    NotificationChannel(
                        HEADLESS_NOTIF_CHANNEL,
                        context.getString(R.string.notification_headless_title),
                        NotificationManager.IMPORTANCE_DEFAULT
                    ).apply {
                        description = context.getString(R.string.notification_headless_desc)
                    },
                    NotificationChannel(
                        channelId,
                        channelName,
                        NotificationManager.IMPORTANCE_DEFAULT
                    ).apply {
                        description = channelDesc
                    },
                )
            )
        }
    }

    fun notifyRunningHeadless(context: Context): Notification {
        return NotificationCompat.Builder(context, HEADLESS_NOTIF_CHANNEL).apply {
            setContentTitle(context.getString(R.string.notif_headless_title_default))
            setSmallIcon(R.mipmap.ic_stat_ic_notification)
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
}