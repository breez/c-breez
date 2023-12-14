package com.cBreez.client

import android.util.Log
import androidx.work.BackoffPolicy
import androidx.work.Constraints
import androidx.work.ExistingWorkPolicy
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequest
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager
import androidx.work.WorkRequest.Companion.DEFAULT_BACKOFF_DELAY_MILLIS
import androidx.work.workDataOf
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import java.util.concurrent.TimeUnit


class BreezFCMService : FirebaseMessagingService() {

    companion object {
        private const val TAG = "BreezFCMService"
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage);
        Log.d(TAG, "From: ${remoteMessage.from}")

        // Check if message contains a data payload.
        if (remoteMessage.data.isNotEmpty()) {
            Log.d(TAG, "Message data payload: ${remoteMessage.data}")

            if (remoteMessage.data["notification_type"] == "payment_received") {
                val paymentHash = remoteMessage.data["payment_hash"];
                paymentHash?.let { handleNow(it) }
            }
        }
    }

    private fun handleNow(paymentHash: String) {
        // Set Constraints for notification to be handled at all times when device is connected to a network
        val constraints = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .setRequiresBatteryNotLow(false)
            .setRequiresCharging(false)
            .setRequiresDeviceIdle(false)
            .setRequiresStorageNotLow(false)
            .build()

        // Create expedited work request
        val paymentReceivedWorkRequest: OneTimeWorkRequest =
            OneTimeWorkRequestBuilder<BreezSdkWorker>()
                .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
                .setConstraints(constraints)
                .setBackoffCriteria(
                    BackoffPolicy.LINEAR,
                    DEFAULT_BACKOFF_DELAY_MILLIS,
                    TimeUnit.MILLISECONDS
                )
                .addTag("receivePayment")
                .setInputData(
                    workDataOf(
                        "PAYMENT_HASH" to paymentHash
                    )
                )
                .build()

        // Enqueue unique work
        WorkManager
            .getInstance(applicationContext)
            .enqueueUniqueWork(
                paymentHash,
                ExistingWorkPolicy.KEEP,
                paymentReceivedWorkRequest
            )
    }
}