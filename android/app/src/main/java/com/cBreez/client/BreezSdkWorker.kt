package com.cBreez.client

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.SharedPreferences
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.work.CoroutineWorker
import androidx.work.ForegroundInfo
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
import com.cBreez.client.Constants.NOTIFICATION_ID_PAYMENT_RECEIVED
import io.flutter.util.PathUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Dispatchers.Main
import kotlinx.coroutines.Job
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.util.Timer
import java.util.TimerTask


// SDK events listener
class SDKListener(private val paymentListener: (payment: Payment) -> Job) : EventListener {
    override fun onEvent(e: BreezEvent) {
        Log.v(TAG, "Received event $e")
        if (e is BreezEvent.InvoicePaid) {
            Log.v(
                TAG,
                "Received payment. Bolt11: ${e.details.bolt11}\nPayment Hash:${e.details.paymentHash}"
            )
            e.details.payment?.let {
                paymentListener(it)
            }
        }
    }

    companion object {
        private const val TAG = "SDKListener"
    }
}

open class BreezSdkWorker(appContext: Context, workerParams: WorkerParameters) :
    CoroutineWorker(appContext, workerParams) {
    private var preferences: SharedPreferences? = null
    private var breezSDK: BlockingBreezServices? = null
    private var receivedPayments: ArrayList<String> = ArrayList()
    private var paymentHashPollerTimer: Timer? = null

    override suspend fun getForegroundInfo(): ForegroundInfo {
        return ForegroundInfo(
            NOTIFICATION_ID_PAYMENT_RECEIVED,
            createNotification(
                "Incoming payment",
                NotificationManager.IMPORTANCE_LOW,
                true
            )
        )
    }

    override suspend fun doWork(): Result = coroutineScope {
        val paymentHash =
            inputData.getString("PAYMENT_HASH") ?: return@coroutineScope Result.failure()
        CoroutineScope(Dispatchers.Default).launch {
            receivedPayments.add(paymentHash)
            if (breezSDK == null) {
                try {
                    breezSDK = connectSDK { payment ->
                        CoroutineScope(Dispatchers.Default).launch {
                            onPaymentReceived(payment)
                        }
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Failure during connecting to Breez SDK", e)
                    shutdown()
                }
            }
            startPaymentHashPollerTimer()
        }

        return@coroutineScope Result.success()
    }

    private fun connectSDK(paymentListener: (payment: Payment) -> Job): BlockingBreezServices {
        // Select your seed, invite code and environment
        // TODO(_): Read mnemonic from Keystore
        val mnemonic: String = "<your-mnemonic>"
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
        for (paymentHash in this.receivedPayments) {
            createNotification("Receive payment failed")
        }
        // Empty the received payments list and cancel payment hash poller timer
        receivedPayments.clear()
        paymentHashPollerTimer?.cancel()
        paymentHashPollerTimer?.purge()
    }

    private fun startPaymentHashPollerTimer() {
        // Poll payment hash every second in case it's BreezEvent is missed
        paymentHashPollerTimer = Timer().apply {
            schedule(object : TimerTask() {
                override fun run() {
                    receivedPayments.forEach { paymentHash ->
                        try {
                            val payment = breezSDK?.paymentByHash(paymentHash)
                            if (payment?.status == PaymentStatus.COMPLETE) {
                                onPaymentReceived(payment)
                            }
                        } catch (e: Exception) {
                            // handle exception
                        }
                    }
                }
            }, 0, 1000)
        }
    }

    private fun onPaymentReceived(payment: Payment) {
        val paymentDetails = payment.details
        if (paymentDetails is PaymentDetails.Ln) {
            val data = paymentDetails.guard { return }
            for (paymentHash in this.receivedPayments) {
                if (paymentHash == data.data.paymentHash) {
                    createNotification("Received ${payment.amountMsat / 1000u} sats")
                }
            }
            this.receivedPayments.removeAll { it == data.data.paymentHash }
        }
    }

    private fun createNotification(
        contentText: String?,
        importance: Int = NotificationManager.IMPORTANCE_DEFAULT,
        setOngoing: Boolean = false
    ): Notification {
        val channelId =
            applicationContext.getString(R.string.offline_payments_notification_channel_id)
        val channelName =
            applicationContext.getString(R.string.offline_payments_notification_channel_name)
        val channelDesc =
            applicationContext.getString(R.string.offline_payments_notification_channel_description)

        val notificationIcon = R.mipmap.ic_stat_ic_notification
        val notificationColor = applicationContext.getColor(R.color.breez_notification_color)

        val notification =
            NotificationCompat.Builder(applicationContext, channelId)
                .setSmallIcon(notificationIcon)
                .setColor(notificationColor)
                .setContentText(contentText)
                .setAutoCancel(true) // Required for notification to persist after work is complete
                .setOngoing(setOngoing) // Required for notification to persist after work is complete
                .build()

        val notificationManager =
            applicationContext.getSystemService(Context.NOTIFICATION_SERVICE)
                    as NotificationManager

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N || notificationManager.areNotificationsEnabled()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val mChannel = NotificationChannel(channelId, channelName, importance)
                mChannel.description = channelDesc
                // Register the channel with the system. You can't change the importance
                // or other notification behaviors after this.
                if (notificationManager.getNotificationChannel(channelId) == null) {
                    notificationManager.createNotificationChannel(mChannel)
                }
            }
            // Required for notification to persist after work is complete
            CoroutineScope(Main).launch {
                delay(200)
                notificationManager.notify(NOTIFICATION_ID_PAYMENT_RECEIVED, notification)
            }
        }
        return notification
    }

    private inline fun <T> T.guard(block: T.() -> Unit): T {
        if (this == null) block(); return this
    }

    companion object {
        private const val TAG = "BreezSdkWorker"
    }
}