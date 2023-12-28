package com.cBreez.client

object Constants {
    // Keystore
    const val ACCOUNT_MNEMONIC = "account_mnemonic"

    // Notification Channels
    const val NOTIFICATION_CHANNEL_FOREGROUND_SERVICE =
        "${BuildConfig.APPLICATION_ID}.FOREGROUND_SERVICE"
    const val NOTIFICATION_CHANNEL_PAYMENT_RECEIVED = "${BuildConfig.APPLICATION_ID}.PAYMENT_FAILED"
    const val NOTIFICATION_CHANNEL_PAYMENT_FAILED = "${BuildConfig.APPLICATION_ID}.PAYMENT_FAILED"

    // Notification Ids
    const val NOTIFICATION_ID_FOREGROUND_SERVICE = 100
    const val NOTIFICATION_ID_PAYMENT_RECEIVED = 201
    const val NOTIFICATION_ID_PAYMENT_FAILED = 202

    // Dismiss Action
    const val DISMISS_ACTION = "DISMISS_ACTION"
}