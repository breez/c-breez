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
import breez_sdk.PaymentDetails
import com.cBreez.client.BreezNotificationService.Companion.createNotification
import com.cBreez.client.Constants.NOTIFICATION_ID_PAYMENT_RECEIVED
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock


// SDK events listener
class SDKListener(private val paymentListener: (payment: Payment) -> Unit) : EventListener {
    companion object {
        private const val TAG = "SDKListener"
    }

    override fun onEvent(e: BreezEvent) {
        Log.v(TAG, "Received event $e")
        if (e is BreezEvent.InvoicePaid) {
            val pD = e.details
            Log.v(TAG, "Received payment. Bolt11: ${pD.bolt11}\nPayment Hash:${pD.paymentHash}")
            pD.payment?.let { paymentListener(it) }
        }
    }
}

open class BreezSdkWorker(appContext: Context, workerParams: WorkerParameters) :
    Worker(appContext, workerParams) {
    companion object {
        private const val TAG = "BreezSdkWorker"

        private var mutex = Mutex()
        internal var breezSDK: BlockingBreezServices? = null
        internal var receivedPayments: ArrayList<String> = ArrayList()
        internal var timerList: ArrayList<PaymentHashPoller> = ArrayList()
    }

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
            synchronized(this) {
                startPaymentReceivedJob()
            }
        } catch (e: Exception) {
            shutdown()
            return Result.failure()
        }
        return Result.success()
    }

    private fun startPaymentReceivedJob() {
        val paymentHash =
            inputData.getString("PAYMENT_HASH") ?: throw Exception("Couldn't find payment hash")
        if (receivedPayments.contains(paymentHash)) {
            Log.i(TAG, "There's already a running job for this payment($paymentHash).")
            return
        }
        receivedPayments.add(paymentHash)
        if (breezSDK == null) {
            try {
                val paymentListener: (payment: Payment) -> Unit = { payment ->
                    CoroutineScope(Dispatchers.Default).launch {
                        mutex.withLock {
                            onPaymentReceived(payment)
                        }
                    }
                }
                breezSDK = BreezSdkConnector(applicationContext, paymentListener).breezSDK
            } catch (e: Exception) {
                Log.e(TAG, "Failure during connecting to Breez SDK. Shutting down.", e)
                shutdown()
            }
        }
        // TODO: Add timeout to all payment has poller timers as they seem to run for a very long time, at least 1h+
        startPaymentHashPollerTimer(paymentHash)
    }

    private fun shutdown() {
        // Display a notification for each remaining payment in list
        if (receivedPayments.size != 0) {
            val contentText = applicationContext.resources.getQuantityString(
                R.plurals.failed_notification_message, receivedPayments.size
            )
            createNotification(
                applicationContext,
                contentText,
                NOTIFICATION_ID_PAYMENT_RECEIVED,
            )
        }
        // Empty the received payments list and cancel payment hash poller timer
        breezSDK = null
        receivedPayments.clear()
        timerList.forEach { timer ->
            timer.cancel()
        }
    }

    private fun startPaymentHashPollerTimer(paymentHash: String) {
        // Todo: Remove this condition as there shouldn't be an existing job for the same payment hash
        if (!containsTimer(paymentHash)) {
            // Create a separate timer for each notification
            CoroutineScope(Dispatchers.Main).launch {
                // Todo: No need to lock thread for the same reason above
                mutex.withLock {
                    // Poll payment hash every second for a minute in case it's BreezEvent is missed
                    var paymentHashPollerTimer = PaymentHashPoller(paymentHash, { payment ->
                        onPaymentReceived(payment)
                    }, {
                        stopPaymentHashPollerTimer(paymentHash)
                    })
                    paymentHashPollerTimer.start()
                    timerList.add(paymentHashPollerTimer)
                }
            }
        }
    }

    private fun stopPaymentHashPollerTimer(paymentHash: String) {
        Log.v(TAG, "Cancel PaymentHashPoller for: $paymentHash.")
        receivedPayments.remove(paymentHash)
        receivedPayments.removeIf { it == paymentHash }
        timerList.removeIf { it.paymentHash == paymentHash }
    }

    private fun onPaymentReceived(payment: Payment) {
        val paymentDetails = payment.details
        if (paymentDetails is PaymentDetails.Ln) {
            val data = paymentDetails.guard { return }
            if (receivedPayments.contains(data.data.paymentHash)) {
                createNotification(
                    applicationContext, "Received ${payment.amountMsat / 1000u} sats"
                )
            }
            receivedPayments.removeIf { it == data.data.paymentHash }
        }
    }

    private inline fun <T> T.guard(block: T.() -> Unit): T {
        if (this == null) block(); return this
    }

    open fun containsTimer(paymentHash: String): Boolean {
        for (timer in timerList) {
            if (timer.paymentHash == paymentHash) {
                Log.i(
                    TAG,
                    "There's already a running payment hash poller for this payment($paymentHash)."
                )
                return true
            }
        }
        return false
    }
}