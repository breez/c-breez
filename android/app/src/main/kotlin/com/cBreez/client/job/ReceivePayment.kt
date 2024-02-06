package com.cBreez.client.job

import android.content.Context
import breez_sdk.BlockingBreezServices
import breez_sdk.BreezEvent
import breez_sdk.Payment
import com.cBreez.client.BreezNotificationHelper.Companion.notifyChannel
import com.cBreez.client.Constants
import com.cBreez.client.ForegroundService
import com.cBreez.client.R
import org.tinylog.kotlin.Logger

class PaymentReceiverJob(
    private val context: Context,
    private val fgService: ForegroundService,
    private val data: JobData
) : SDKJob {
    private var receivedPayment: Payment? = null

    companion object {
        private const val TAG = "PaymentReceiverJob"
    }

    override fun start(breezSDK: BlockingBreezServices) {}

    override fun onEvent(e: BreezEvent) {
        Logger.tag(TAG).trace { "Received event $e" }
        when (e) {
            is BreezEvent.InvoicePaid -> {
                val pd = e.details
                handleReceivedPayment(pd.bolt11, pd.paymentHash, pd.payment?.amountMsat)
                receivedPayment = pd.payment

                // Push back shutdown by SHUTDOWN_DELAY_MS for payments synced event
                fgService.pushbackShutdown()
            }

            is BreezEvent.Synced -> {
                receivedPayment?.let {
                    Logger.tag(TAG).info { "Got synced event for received payment." }
                    fgService.shutdown()
                }
            }

            else -> {}
        }
    }

    private fun handleReceivedPayment(
        bolt11: String,
        paymentHash: String,
        amountMsat: ULong?,
    ) {
        Logger.tag(TAG)
            .info { "Received payment. Bolt11:${bolt11}\nPayment Hash:${paymentHash}" }
        val amountSat = (amountMsat ?: ULong.MIN_VALUE) / 1000u
        notifyChannel(
            context,
            Constants.NOTIFICATION_CHANNEL_PAYMENT_RECEIVED,
            context.getString(R.string.payment_received_notification_title),
            "Received $amountSat sats"
        )
    }
}
