package com.cBreez.client

object Constants {
    const val SHUTDOWN_DELAY_MS = 60 * 1000L

    // Keystore
    const val ACCOUNT_MNEMONIC = "account_mnemonic"

    // Notification Channels
    const val NOTIFICATION_CHANNEL_FOREGROUND_SERVICE =
        "${BuildConfig.APPLICATION_ID}.FOREGROUND_SERVICE"
    const val NOTIFICATION_CHANNEL_LNURL_PAY =
        "${BuildConfig.APPLICATION_ID}.LNURL_PAY"
    const val NOTIFICATION_CHANNEL_PAYMENT_RECEIVED =
        "${BuildConfig.APPLICATION_ID}.PAYMENT_RECEIVED"
    const val NOTIFICATION_CHANNEL_SWAP_TX_CONFIRMED =
        "${BuildConfig.APPLICATION_ID}.SWAP_TX_CONFIRMED"

    // Notification Ids
    const val NOTIFICATION_ID_FOREGROUND_SERVICE = 100

    // Intent Extras
    const val EXTRA_REMOTE_MESSAGE = "remote_message"
}