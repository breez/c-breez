package com.cBreez.client

object Constants {
    // Keystore
    const val ACCOUNT_MNEMONIC = "account_mnemonic"

    // Notification Channels
    const val NOTIFICATION_CHANNEL_FOREGROUND_SERVICE =
        "${BuildConfig.APPLICATION_ID}.FOREGROUND_SERVICE"
    const val NOTIFICATION_CHANNEL_PAYMENT_RECEIVED =
        "${BuildConfig.APPLICATION_ID}.PAYMENT_RECEIVED"

    // Notification Ids
    const val NOTIFICATION_ID_FOREGROUND_SERVICE = 100

    // Intent Extras
    const val EXTRA_REMOTE_MESSAGE = "remote_message"
}