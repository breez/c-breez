package com.cBreez.client

import android.content.Context
import android.util.Base64
import breez_sdk.*
import com.cBreez.client.Constants.ACCOUNT_MNEMONIC
import io.flutter.util.PathUtils
import org.tinylog.kotlin.Logger
import java.nio.charset.Charset

class BreezSdkConnector {
    companion object {
        private const val TAG = "BreezSdkConnector"

        private var breezSDK: BlockingBreezServices? = null
        private var ELEMENT_PREFERENCES_KEY_PREFIX =
            "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIHNlY3VyZSBzdG9yYWdlCg"

        internal fun connectSDK(
            applicationContext: Context,
            sdkListener: EventListener,
        ): BlockingBreezServices {
            synchronized(this) {
                if (breezSDK == null) {
                    Logger.tag(TAG).trace { "connectSDK()" }

                    // Create the default config
                    val apiKey = applicationContext.getString(R.string.breezApiKey)
                    Logger.tag(TAG).trace { "API_KEY: $apiKey" }
                    val glNodeConf = GreenlightNodeConfig(null, null)
                    val nodeConf = NodeConfig.Greenlight(glNodeConf)
                    val config = defaultConfig(EnvironmentType.PRODUCTION, apiKey, nodeConf)

                    config.workingDir = PathUtils.getDataDirectory(applicationContext)

                    // Construct the seed
                    // TODO: Add null & error handling for mnemonic & seed and escape early
                    val mnemonic = readSecuredValued(applicationContext, ACCOUNT_MNEMONIC)
                    val seed = mnemonicToSeed(mnemonic!!)

                    // Connect to the Breez SDK make it ready for use
                    Logger.tag(TAG).debug { "Connecting to Breez SDK" }
                    breezSDK = connect(config, seed, sdkListener)
                    Logger.tag(TAG).debug { "Connected to Breez SDK" }
                } else Logger.tag(TAG).debug { "Already connected to Breez SDK" }

                return breezSDK!!
            }
        }

        @Throws(java.lang.Exception::class)
        fun readSecuredValued(appContext: Context, key: String?): String? {
            val preferences =
                appContext.getSharedPreferences("FlutterSecureStorage", Context.MODE_PRIVATE)
            val rawValue = preferences.getString(ELEMENT_PREFERENCES_KEY_PREFIX + "_" + key, null)
            return decodeRawValue(appContext, rawValue)
        }

        @Throws(java.lang.Exception::class)
        private fun decodeRawValue(appContext: Context, value: String?): String? {
            if (value == null) {
                return null
            }
            val charset = Charset.forName("UTF-8")
            val data: ByteArray = Base64.decode(value, 0)
            val keyCipherAlgo = RSACipher18Implementation(context = appContext)
            val storageCipher = StorageCipher18Implementation(appContext, keyCipherAlgo)
            val result: ByteArray = storageCipher.decrypt(data)
            return String(result, charset)
        }
    }
}