package com.cBreez.client.job

import android.content.Context
import breez_sdk.BlockingBreezServices
import breez_sdk.BreezEvent
import com.cBreez.client.BreezNotificationHelper.Companion.notifyChannel
import com.cBreez.client.Constants
import com.cBreez.client.ForegroundService
import com.cBreez.client.R
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import org.tinylog.kotlin.Logger

@Serializable
data class AddressTxsConfirmedRequest(
    val address: String,
)

class RedeemSwapJob(
    private val context: Context,
    private val fgService: ForegroundService,
    private val payload: String,
) : SDKJob {
    companion object {
        private const val TAG = "RedeemSwapJob"
    }

    override fun start(breezSDK: BlockingBreezServices) {
        try {
            val request = Json.decodeFromString(AddressTxsConfirmedRequest.serializer(), payload)
            breezSDK.redeemSwap(request!!.address)
            Logger.tag(TAG).info { "Found swap for ${request.address}" }
            notifyChannel(
                context,
                Constants.NOTIFICATION_CHANNEL_SWAP_TX_CONFIRMED,
                context.getString(R.string.swap_tx_notification_title),
            )
        } catch (e: Exception) {
            Logger.tag(TAG).warn { "Failed to process swap notification: ${e.message}" }
            notifyChannel(
                context,
                Constants.NOTIFICATION_CHANNEL_SWAP_TX_CONFIRMED,
                context.getString(R.string.swap_tx_notification_failure_title),
            )
        }

        fgService.shutdown()
    }

    override fun onEvent(e: BreezEvent) {}
}
