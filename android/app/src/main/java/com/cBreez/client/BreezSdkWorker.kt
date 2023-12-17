package com.cBreez.client

import android.app.NotificationManager
import android.content.Context
import android.util.Log
import androidx.work.ForegroundInfo
import androidx.work.Worker
import androidx.work.WorkerParameters
import breez_sdk.BlockingBreezServices
import breez_sdk.BreezEvent
import breez_sdk.EventListener
import breez_sdk.Payment
import breez_sdk.PaymentStatus
import com.cBreez.client.BreezNotificationService.Companion.createNotification
import com.cBreez.client.Constants.NOTIFICATION_ID_PAYMENT_RECEIVED


// SDK events listener
class SDKListener() : EventListener {
    companion object {
        private const val TAG = "SDKListener"
    }

    override fun onEvent(e: BreezEvent) {
        Log.v(TAG, "Received event $e")
        if (e is BreezEvent.InvoicePaid) {
            val pD = e.details
            Log.v(TAG, "Received payment. Bolt11: ${pD.bolt11}\nPayment Hash:${pD.paymentHash}")
        }
    }
}

open class BreezSdkWorker(appContext: Context, workerParams: WorkerParameters) :
    Worker(appContext, workerParams) {
    private val TAG = "BreezSdkWorker"
    private var breezSDK: BlockingBreezServices? = null

    override fun getForegroundInfo(): ForegroundInfo {
        return ForegroundInfo(
            NOTIFICATION_ID_PAYMENT_RECEIVED, createNotification(
                applicationContext,
                "Receiving payment...",
                NOTIFICATION_ID_PAYMENT_RECEIVED,
                NotificationManager.IMPORTANCE_LOW,
                true
            )
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
                    Log.v(TAG,"Payment w/ paymentHash: $paymentHash not received yet.")
                    Thread.sleep(1_000)
                }
            }

            // If we reach here then we didn't receive for more than 1 minute
            throw Exception("Payment not found before timeout")

        } catch (e: Exception) {
            Log.e(TAG, "Exception: ${e.toString()}")
            e.printStackTrace()
            onPaymentFailed()
            return Result.failure()
        }
    }

    override fun onStopped() {
        this.onPaymentFailed()
    }

    private fun onPaymentFailed() {
        // Display a notification for each remaining payment in list
        var contentText = "Failed to receive payment"
        createNotification(
            applicationContext,
            contentText,
            NOTIFICATION_ID_PAYMENT_RECEIVED,
        )
    }

    private fun onPaymentReceived(payment: Payment) {
        createNotification(
            applicationContext,
            "Received ${payment.amountMsat / 1000u} sats",
            NOTIFICATION_ID_PAYMENT_RECEIVED
        )
    }

    private inline fun <T> T.guard(block: T.() -> Unit): T {
        if (this == null) block(); return this
    }
}