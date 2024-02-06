package com.cBreez.client.job

import android.content.Context
import breez_sdk.BlockingBreezServices
import breez_sdk.ReceivePaymentRequest
import breez_sdk.SdkException
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
data class LnurlInvoiceRequest(
    @SerialName("amount") val amount: ULong,
    @SerialName("reply_url") val replyURL: String,
)

@Serializable
data class LnurlPayInvoiceResponse(
    @SerialName("pr") val pr: String,
    @SerialName("routes") val routes: List<String>,
)

class LnurlPayInvoiceJob(
    private val context: Context,
    private val fgService: ForegroundService,
    private val payload: String,
) : LnurlPayJob {
    companion object {
        private const val TAG = "LnurlPayInvoiceJob"
    }

    override fun start(breezSDK: BlockingBreezServices) {
        val request = Json.decodeFromString<LnurlInvoiceRequest>(payload)
        try {
            val nodeState = breezSDK.nodeInfo()
            if (request.amount < 1000UL || request.amount > nodeState.inboundLiquidityMsats) {
                fail("Invalid amount requested ${request.amount}", request.replyURL)
                notifyChannel(
                    context,
                    Constants.NOTIFICATION_CHANNEL_LNURL_PAY,
                    context.getString(R.string.lnurl_pay_notification_failure_title),
                )
                return
            }
            val receivePaymentResponse = breezSDK.receivePayment(
                ReceivePaymentRequest(
                    request.amount,
                    description = METADATA,
                    useDescriptionHash = true
                )
            )
            val response =
                LnurlPayInvoiceResponse(
                    receivePaymentResponse.lnInvoice.bolt11,
                    listOf(),
                )
            val success = replyServer(Json.encodeToString(response), request.replyURL)
            notifyChannel(
                context,
                Constants.NOTIFICATION_CHANNEL_LNURL_PAY,
                context.getString(if (success) R.string.lnurl_pay_invoice_notification_title else R.string.lnurl_pay_notification_failure_title),
            )
        } catch (e: SdkException) {
            Logger.tag(TAG).warn { "Failed to process lnurl: ${e.message}" }
            fail(e.message, request.replyURL)
            notifyChannel(
                context,
                Constants.NOTIFICATION_CHANNEL_LNURL_PAY,
                context.getString(R.string.lnurl_pay_notification_failure_title),
            )
        }

        fgService.shutdown()
    }
}
