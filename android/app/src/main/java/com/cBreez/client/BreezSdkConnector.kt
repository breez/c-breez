package com.cBreez.client

import android.content.Context
import android.util.Base64
import breez_sdk.*
import io.flutter.util.PathUtils
import org.tinylog.kotlin.Logger
import java.nio.charset.Charset

class BreezSdkConnector {
    companion object {
        private var breezSDK: BlockingBreezServices? = null
        private var ELEMENT_PREFERENCES_KEY_PREFIX =
            "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIHNlY3VyZSBzdG9yYWdlCg"

        internal fun connectSDK(applicationContext: Context): BlockingBreezServices {
            synchronized(this) {
                if (breezSDK == null) {
                    Logger.info { "Connecting to Breez SDK" }
                    val mnemonic = readSecuredValued(applicationContext, Constants.ACCOUNT_MNEMONIC)
                    val seed = mnemonicToSeed(mnemonic!!)
                    val apiKey = applicationContext.getString(R.string.breezApiKey)
                    // Create the default config
                    val glNodeConf = GreenlightNodeConfig(null, null)
                    val nodeConf = NodeConfig.Greenlight(glNodeConf)
                    val config = defaultConfig(EnvironmentType.PRODUCTION, apiKey, nodeConf)
                    config.workingDir = PathUtils.getDataDirectory(applicationContext)
                    // Connect to the Breez SDK make it ready for use
                    breezSDK = connect(config, seed, SDKListener())
                    Logger.info { "Connected to Breez SDK" }
                }
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