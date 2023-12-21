package com.cBreez.client

import android.content.Context
import androidx.work.BackoffPolicy
import androidx.work.Constraints
import androidx.work.ExistingWorkPolicy
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequest
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager
import androidx.work.WorkRequest
import androidx.work.workDataOf
import org.tinylog.Logger
import java.util.concurrent.TimeUnit

class JobManager private constructor() {
    companion object {
        private const val TAG = "JobManager"

        var instance = JobManager()
    }

    fun startPaymentReceivedJob(applicationContext: Context, paymentHash: String) {
        try {
            Logger.tag(TAG).info { "Enqueueing work request for $paymentHash" }
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
                        WorkRequest.DEFAULT_BACKOFF_DELAY_MILLIS,
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
            Logger.tag(TAG).info { "Work request for $paymentHash was enqueued successfully" }
        } catch (e: Exception) {
            Logger.tag(TAG).error { "Failed to enqueue job from notification " + e.message; e }
        }
    }
}