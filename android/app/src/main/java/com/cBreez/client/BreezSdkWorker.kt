package com.cBreez.client

import android.app.NotificationManager
import android.content.Context
import android.util.Log
import androidx.work.ForegroundInfo
import androidx.work.Worker
import androidx.work.WorkerParameters
import breez_sdk.BlockingBreezServices
import breez_sdk.BreezEvent
import breez_sdk.EnvironmentType
import breez_sdk.EventListener
import breez_sdk.GreenlightNodeConfig
import breez_sdk.NodeConfig
import breez_sdk.Payment
import breez_sdk.PaymentDetails
import breez_sdk.PaymentStatus
import breez_sdk.connect
import breez_sdk.defaultConfig
import breez_sdk.mnemonicToSeed
import com.cBreez.client.BreezNotificationService.Companion.createNotification
import com.cBreez.client.Constants.NOTIFICATION_ID_PAYMENT_RECEIVED
import io.flutter.util.PathUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import java.util.Timer
import java.util.TimerTask


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
        private var breezSDK: BlockingBreezServices? = null
        private var receivedPayments: ArrayList<String> = ArrayList()
        private var timerList: ArrayList<Timer> = ArrayList()
    }

    override fun getForegroundInfo(): ForegroundInfo {
        return ForegroundInfo(
            NOTIFICATION_ID_PAYMENT_RECEIVED,
            createNotification(
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

        receivedPayments.add(paymentHash)
        if (breezSDK == null) {
            try {
                breezSDK = connectSDK { payment ->
                    CoroutineScope(Dispatchers.Default).launch {
                        mutex.withLock {
                            onPaymentReceived(payment)
                        }
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Failure during connecting to Breez SDK. Shutting down.", e)
                shutdown()
            }
        }
        // TODO: Add timeout to all payment has poller timers as they seem to run for a very long time, at least 1h+
        startPaymentHashPollerTimer()
    }

    private fun connectSDK(paymentListener: (payment: Payment) -> Unit): BlockingBreezServices {
        // Select your seed, invite code and environment
        // TODO(_): Read mnemonic from Keystore
        val mnemonic = "<your-mnemonic>"
        val seed = mnemonicToSeed(mnemonic)
        val apiKey = applicationContext.getString(R.string.breezApiKey)

        // Create the default config
        val glNodeConf = GreenlightNodeConfig(null, null)
        val nodeConf = NodeConfig.Greenlight(glNodeConf)
        val config = defaultConfig(EnvironmentType.PRODUCTION, apiKey, nodeConf)
        config.workingDir = PathUtils.getDataDirectory(applicationContext)
        // Connect to the Breez SDK make it ready for use
        return connect(config, seed, SDKListener(paymentListener))
    }

    private fun shutdown() {
        // Display a notification for each remaining payment in list
        for (paymentHash in receivedPayments) {
            Log.v(TAG, "Couldn't handle payment $paymentHash in time")
            createNotification(
                applicationContext,
                "Receive payment failed",
                NOTIFICATION_ID_PAYMENT_RECEIVED,
            )
        }
        // Empty the received payments list and cancel payment hash poller timer
        breezSDK = null
        receivedPayments.clear()
        timerList.forEach { timer ->
            timer.cancel()
            timer.purge()
        }
    }

    private fun startPaymentHashPollerTimer() {
        // Poll payment hash every second in case it's BreezEvent is missed
        val paymentHashPollerTimer = Timer().apply {
            schedule(object : TimerTask() {
                override fun run() {
                    receivedPayments.forEach { paymentHash ->
                        try {
                            Log.v(TAG, "Polling for payment w/ paymentHash: $paymentHash")
                            val payment = breezSDK?.paymentByHash(paymentHash)
                            if (payment?.status == PaymentStatus.COMPLETE) {
                                Log.v(
                                    TAG, "Payment received w/ paymentHash: $paymentHash. \n" +
                                            "$payment"
                                )
                                onPaymentReceived(payment)
                                this.cancel()
                            } else {
                                Log.v(
                                    TAG,
                                    "Payment w/ paymentHash: $paymentHash not received yet.\n$payment"
                                )
                            }
                        } catch (e: Exception) {
                            // handle exception
                        }
                    }
                }
            }, 0, 1000)
        }
        timerList.add(paymentHashPollerTimer)
    }

    private fun onPaymentReceived(payment: Payment) {
        val paymentDetails = payment.details
        if (paymentDetails is PaymentDetails.Ln) {
            val data = paymentDetails.guard { return }
            for (paymentHash in receivedPayments) {
                if (paymentHash == data.data.paymentHash) {
                    createNotification(
                        applicationContext,
                        "Received ${payment.amountMsat / 1000u} sats"
                    )
                }
            }
            receivedPayments.removeAll { it == data.data.paymentHash }
        }
    }

    private inline fun <T> T.guard(block: T.() -> Unit): T {
        if (this == null) block(); return this
    }
}