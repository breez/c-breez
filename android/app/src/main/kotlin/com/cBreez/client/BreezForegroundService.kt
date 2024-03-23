package com.cBreez.client

import android.content.SharedPreferences
import breez_sdk.ConnectRequest
import breez_sdk.EnvironmentType
import breez_sdk.GreenlightNodeConfig
import breez_sdk.LevelFilter
import breez_sdk.LogEntry
import breez_sdk.NodeConfig
import breez_sdk.defaultConfig
import breez_sdk.mnemonicToSeed
import breez_sdk_notification.ForegroundService
import breez_sdk_notification.NotificationHelper.Companion.registerNotificationChannels
import breez_sdk_notification.ServiceConfig
import com.breez.breez_sdk.SdkLogInitializer
import com.cBreez.client.utils.FlutterSecuredStorageHelper.Companion.readSecuredValue
import io.flutter.util.PathUtils
import org.tinylog.kotlin.Logger

class BreezForegroundService : ForegroundService() {
    companion object {
        private const val TAG = "BreezForegroundService"

        private const val SHARED_PREFERENCES_NAME = "FlutterSharedPreferences"
        private const val kChannelSetupFeeLimit =
            "flutter.payment_options_channel_setup_fee_limit"
        private const val ACCOUNT_MNEMONIC = "account_mnemonic"
        private const val DEFAULT_CLICK_ACTION = "FLUTTER_NOTIFICATION_CLICK"
        private const val ELEMENT_PREFERENCES_KEY_PREFIX =
            "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIHNlY3VyZSBzdG9yYWdlCg"
    }

    override fun onCreate() {
        super.onCreate()
        Logger.tag(TAG).debug { "Creating Breez foreground service..." }
        registerNotificationChannels(applicationContext, DEFAULT_CLICK_ACTION)
        val sdkLogListener = SdkLogInitializer.initializeNodeLogStream(LevelFilter.DEBUG)
        sdkLogListener.subscribe(serviceScope) { l: LogEntry ->
            when (l.level) {
                "ERROR" -> Logger.tag(TAG).error { l.line }
                "WARN" -> Logger.tag(TAG).warn { l.line }
                "INFO" -> Logger.tag(TAG).info { l.line }
                "DEBUG" -> Logger.tag(TAG).debug { l.line }
                "TRACE" -> Logger.tag(TAG).trace { l.line }
            }
        }
        setLogger(sdkLogListener)
        Logger.tag(TAG).debug { "Breez foreground service created." }
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

    override fun getServiceConfig(): ServiceConfig? {
        return try {
            val sharedPreferences: SharedPreferences = applicationContext.getSharedPreferences(
                SHARED_PREFERENCES_NAME,
                MODE_PRIVATE
            )
            val channelFeeLimitMsat =
                sharedPreferences.getLong(kChannelSetupFeeLimit, 0).toULong()
            val serviceConfig =
                ServiceConfig(channelFeeLimitMsat = channelFeeLimitMsat)
            Logger.tag(TAG).debug { "Setting service config to $serviceConfig" }
            serviceConfig
        } catch (e: Exception) {
            Logger.tag(TAG).error { "Failed to get service config: ${e.message}" }
            Logger.tag(TAG).debug { "Using default service config." }
            ServiceConfig.default()
        }
    }
}
