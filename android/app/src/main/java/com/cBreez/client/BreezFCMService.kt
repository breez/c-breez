package com.cBreez.client

import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

import breez_sdk.BreezEvent
import breez_sdk.EnvironmentType
import breez_sdk.EventListener
import breez_sdk.GreenlightNodeConfig
import breez_sdk.NodeConfig
import breez_sdk.connect
import breez_sdk.defaultConfig
import breez_sdk.mnemonicToSeed

// SDK events listener
class SDKListener : EventListener {
    override fun onEvent(e: BreezEvent) {
        Log.v("SDKListener", "Received event $e")
        if (e is BreezEvent.InvoicePaid) {
            // TODO(_): Pass payments from InvoicePaid events to a PaymentListener to be processed
        }
    }
}

const val TAG = "BreezFCMService"

class BreezFCMService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {

        // TODO(developer): Handle FCM messages here.
        // Not getting messages here? See why this may be: https://goo.gl/39bRNJ
        Log.d(TAG, "From: ${remoteMessage.from}")

        // Check if message contains a data payload.
        if (remoteMessage.data.isNotEmpty()) {
            Log.d(TAG, "Message data payload: ${remoteMessage.data}")

            if (/* Check if data needs to be processed by long running job */ true) {
                // For long-running tasks (10 seconds or more) use WorkManager.
                scheduleJob()
            } else {
                // Handle message within 10 seconds
                handleNow()
            }
        }

        // Check if message contains a notification payload.
        remoteMessage.notification?.let {
            Log.d(TAG, "Message Notification Body: ${it.body}")
        }

        // Also if you intend on generating your own notifications as a result of a received FCM
        // message, here is where that should be initiated. See sendNotification method below.
    }

    private fun scheduleJob() {
        // TODO(_): Connect to Breez SDK
        // Select your seed, invite code and enviroment
        val seed = mnemonicToSeed("<mnemonic words>")
        val apiKey = applicationContext.getString(R.string.breezApiKey)

        // Create the default config
        val greenlightNodeConfig = GreenlightNodeConfig(null, null)
        val nodeConfig = NodeConfig.Greenlight(greenlightNodeConfig)
        val config = defaultConfig(EnvironmentType.PRODUCTION, apiKey, nodeConfig)
        // Connect to the Breez SDK make it ready for use
        connect(config, seed, SDKListener())
    }

    private fun handleNow() {
        // TODO
    }
}