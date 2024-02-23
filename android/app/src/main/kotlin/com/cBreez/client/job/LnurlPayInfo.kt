package com.cBreez.client.job

import android.content.Context
import breez_sdk.BlockingBreezServices
import com.cBreez.client.BreezNotificationHelper.Companion.notifyChannel
import com.cBreez.client.Constants
import com.cBreez.client.ForegroundService
import com.cBreez.client.R
import com.cBreez.client.job.LnurlPayJob.Companion.METADATA
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import org.tinylog.kotlin.Logger

@Serializable
data class LnurlInfoRequest(
    @SerialName("callback_url") val callbackURL: String,
    @SerialName("reply_url") val replyURL: String,
)

// Serialize the response according to to LUD-06 payRequest base specification:
// https://github.com/lnurl/luds/blob/luds/06.md
@Serializable
data class LnurlPayInfoResponse(
    val callback: String,
    val maxSendable: ULong,
    val minSendable: ULong,
    val metadata: String,
    val tag: String,
)

class LnurlPayInfoJob(
    private val context: Context,
    private val fgService: ForegroundService,
    private val payload: String,
) : LnurlPayJob {
    companion object {
        private const val TAG = "LnurlPayInfoJob"
    }

    override fun start(breezSDK: BlockingBreezServices) {
        var request: LnurlInfoRequest? = null

        try {
            request = Json.decodeFromString(LnurlInfoRequest.serializer(), payload)
            val nodeState = breezSDK.nodeInfo()
            val response =
                LnurlPayInfoResponse(
                    request!!.callbackURL,
                    nodeState.inboundLiquidityMsats,
                    1000UL,
                    METADATA,
                    "payRequest",
                )
            val success = replyServer(Json.encodeToString(response), request.replyURL)
            notifyChannel(
                context,
                Constants.NOTIFICATION_CHANNEL_LNURL_PAY,
                context.getString(if (success) R.string.lnurl_pay_info_notification_title else R.string.lnurl_pay_notification_failure_title),
            )
        } catch (e: Exception) {
            Logger.tag(TAG).warn { "Failed to process lnurl: ${e.message}" }
            if (request != null) {
                fail(e.message, request.replyURL)
            }
            notifyChannel(
                context,
                Constants.NOTIFICATION_CHANNEL_LNURL_PAY,
                context.getString(R.string.lnurl_pay_notification_failure_title),
            )
        }

        fgService.shutdown()
    }
}
