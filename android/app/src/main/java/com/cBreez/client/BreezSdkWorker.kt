package com.cBreez.client

import android.content.Context
import androidx.work.ForegroundInfo
import androidx.work.Worker
import androidx.work.WorkerParameters
import breez_sdk.BreezEvent
import breez_sdk.EventListener
import breez_sdk.Payment
import breez_sdk.PaymentStatus
import com.cBreez.client.BreezNotificationService.Companion.notifyForegroundService
import com.cBreez.client.BreezNotificationService.Companion.notifyPaymentFailed
import com.cBreez.client.BreezNotificationService.Companion.notifyPaymentReceived
import com.cBreez.client.Constants.NOTIFICATION_ID_FOREGROUND_SERVICE
import org.tinylog.kotlin.Logger

// SDK events listener
class SDKListener : EventListener {
    companion object {
        private const val TAG = "SDKListener"
    }

    override fun onEvent(e: BreezEvent) {
        Logger.tag(TAG).info { "Received event $e" }
        if (e is BreezEvent.InvoicePaid) {
            val pD = e.details
            Logger.tag(TAG)
                .info { "Received payment. Bolt11:${pD.bolt11}\nPayment Hash:${pD.paymentHash}" }
        }
    }
}

open class BreezSdkWorker(appContext: Context, workerParams: WorkerParameters) :
    Worker(appContext, workerParams) {
    companion object {
        private const val TAG = "BreezSdkWorker"
    }

    override fun getForegroundInfo(): ForegroundInfo {

        return ForegroundInfo(
            NOTIFICATION_ID_FOREGROUND_SERVICE, notifyForegroundService(applicationContext)
        )
    }

    override fun doWork(): Result {
        try {
            val paymentHash =
                inputData.getString("PAYMENT_HASH") ?: throw Exception("Couldn't find payment hash")
            val breezSDK = BreezSdkConnector.connectSDK(applicationContext)

            // Poll for 1 minute
            for (i in 1..60) {
                val payment = breezSDK.paymentByHash(paymentHash)
                if (payment?.status == PaymentStatus.COMPLETE) {
                    this.onPaymentReceived(payment)
                    return Result.success()
                } else {
                    Logger.tag(TAG)
                        .info { "Payment w/ paymentHash: $paymentHash not received yet." }
                    Thread.sleep(1_000)
                }
            }

            // If we reach here then we didn't receive for more than 1 minute
            throw Exception("Payment not found before timeout")

        } catch (e: Exception) {
            Logger.tag(TAG).error { "Exception: $e" }
            e.printStackTrace()
            onPaymentFailed()
            return Result.failure()
        }
    }

    override fun onStopped() {
        Logger.tag(TAG).debug { "Stopping BreezSdkWorker" }
        onPaymentFailed()
    }

    private fun onPaymentFailed() {
        notifyPaymentFailed(applicationContext)
    }

    private fun onPaymentReceived(payment: Payment) {
        notifyPaymentReceived(
            applicationContext,
            inputData.getString("CLICK_ACTION"),
            payment.amountMsat / 1000u
        )
    }
}