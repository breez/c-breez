package com.cBreez.client

import android.os.CountDownTimer
import android.util.Log
import breez_sdk.Payment
import breez_sdk.PaymentStatus

class PaymentHashPoller(
    paymentHash: String, onPaymentReceived: (payment: Payment) -> Unit, onFinished: () -> Unit
) : CountDownTimer(60000, 1000) {
    var paymentHash: String
    private var _onPaymentReceived: (payment: Payment) -> Unit
    private var _onFinished: () -> Unit

    init {
        this.paymentHash = paymentHash
        _onPaymentReceived = onPaymentReceived
        _onFinished = onFinished
    }

    companion object {
        val TAG = "PaymentHashPoller"
    }

    override fun onTick(millisUntilFinished: Long) {
        pollPaymentHash(paymentHash)
    }

    override fun onFinish() {
        this.cancel()
        _onFinished
    }

    private fun pollPaymentHash(paymentHash: String) {
        try {
            Log.v(TAG, "Polling for payment w/ paymentHash: $paymentHash")
            val payment = BreezSdkWorker.breezSDK?.paymentByHash(paymentHash)
            if (payment?.status == PaymentStatus.COMPLETE) {
                Log.v(
                    TAG, "Payment received w/ paymentHash: $paymentHash. \n$payment"
                )
                _onPaymentReceived(payment)
                this.cancel()
            } else {
                Log.v(
                    TAG, "Payment w/ paymentHash: $paymentHash not received yet."
                )
                if (payment != null) {
                    Log.v(
                        TAG, "Payment status ${payment.status} for $paymentHash"
                    )
                }
            }
        } catch (e: Exception) {
            // handle exception
        }
    }
}