package com.cBreez.client

import android.content.Intent
import android.os.Build
import androidx.core.content.IntentCompat
import breez_sdk.ConnectRequest
import breez_sdk.EnvironmentType
import breez_sdk.GreenlightNodeConfig
import breez_sdk.LogEntry
import breez_sdk.NodeConfig
import breez_sdk.defaultConfig
import breez_sdk.mnemonicToSeed
import breez_sdk_notification.Constants
import breez_sdk_notification.ForegroundService
import breez_sdk_notification.Notification
import breez_sdk_notification.NotificationHelper.Companion.registerNotificationChannels
import com.breez.breez_sdk.SdkLogInitializer
import com.google.firebase.messaging.RemoteMessage
import flutter_secured_storage.FlutterSecuredStorageHelper.Companion.readSecuredValue
import io.flutter.util.PathUtils
import org.tinylog.kotlin.Logger

class BreezForegroundService : ForegroundService() {
    companion object {
        private const val TAG = "BreezForegroundService"

        private var ACCOUNT_MNEMONIC = "account_mnemonic"
        private var DEFAULT_CLICK_ACTION = "FLUTTER_NOTIFICATION_CLICK"
        private var ELEMENT_PREFERENCES_KEY_PREFIX =
            "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIHNlY3VyZSBzdG9yYWdlCg"
    }

    override fun onCreate() {
        super.onCreate()
        Logger.tag(TAG).debug { "Creating breez foreground service..." }
        registerNotificationChannels(applicationContext, DEFAULT_CLICK_ACTION)
        val sdkLogListener = SdkLogInitializer.initializeNodeLogStream()
        sdkLogListener.subscribe(serviceScope) { l: LogEntry ->
            when (l.level) {
                "ERROR" -> Logger.tag(TAG).error { l.line }
                "WARN" -> Logger.tag(TAG).warn { l.line }
                "INFO" -> Logger.tag(TAG).info { l.line }
                "DEBUG" -> Logger.tag(TAG).debug { l.line }
                "TRACE" -> Logger.tag(TAG).trace { l.line }
            }
        }
        Logger.tag(TAG).debug { "Foreground breez service created." }
    }

    override fun shutdown() {
        SdkLogInitializer.unsubscribeNodeLogStream(serviceScope)
        super.shutdown()
    }

    override fun getConnectRequest(): ConnectRequest? {
        val apiKey = applicationContext.getString(R.string.breezApiKey)
        Logger.tag(TAG).trace { "API_KEY: $apiKey" }
        val glNodeConf = GreenlightNodeConfig(null, null)
        val nodeConf = NodeConfig.Greenlight(glNodeConf)
        val config = defaultConfig(EnvironmentType.PRODUCTION, apiKey, nodeConf)

        config.workingDir = PathUtils.getDataDirectory(applicationContext)

        return readSecuredValue(
            applicationContext,
            "${ELEMENT_PREFERENCES_KEY_PREFIX}_${ACCOUNT_MNEMONIC}"
        )
            ?.let { mnemonic ->
                ConnectRequest(config, mnemonicToSeed(mnemonic))
            }
    }

    override fun getNotification(intent: Intent?): Notification? {
        return intent?.let {
            @Suppress("DEPRECATION")
            val remoteMessage =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
                    IntentCompat.getParcelableExtra(
                        it,
                        Constants.EXTRA_REMOTE_MESSAGE,
                        RemoteMessage::class.java
                    )
                else it.getParcelableExtra(Constants.EXTRA_REMOTE_MESSAGE)
            return remoteMessage?.data?.let { data ->
                return Notification(
                    data[Constants.NOTIFICATION_DATA_TYPE]?.takeUnless { data.isEmpty() },
                    data[Constants.NOTIFICATION_DATA_PAYLOAD]
                )
            }
        }
    }
}
