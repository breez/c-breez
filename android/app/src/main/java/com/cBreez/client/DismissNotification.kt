package com.cBreez.client

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationManagerCompat
import com.cBreez.client.Constants.NOTIFICATION_ID_PAYMENT_FAILED

class DismissNotification : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        NotificationManagerCompat.from(context).cancel(NOTIFICATION_ID_PAYMENT_FAILED)
    }
}