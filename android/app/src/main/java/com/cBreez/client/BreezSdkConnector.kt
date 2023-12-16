package com.cBreez.client

import android.content.Context
import android.util.Base64
import android.util.Log
import breez_sdk.*
import io.flutter.util.PathUtils
import java.nio.charset.Charset

class BreezSdkConnector() {

    companion object {
        private const val TAG = "BreezSdkConnector"
        private var breezSDK: BlockingBreezServices? = null
        private var ELEMENT_PREFERENCES_KEY_PREFIX =
            "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIHNlY3VyZSBzdG9yYWdlCg"

        internal fun connectSDK(applicationContext: Context): BlockingBreezServices {
            synchronized(this) {
                if (breezSDK == null) {
                    Log.i(TAG, "Connecting to Breez SDK")
                    // Select your seed, invite code and environment
                    // TODO(_): Read mnemonic from Keystore
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
                }
                return breezSDK!!
            }
        }


        @Throws(java.lang.Exception::class)
        public fun readSecuredValued(appContext: Context, key: String?): String? {
            val preferences = appContext.getSharedPreferences("FlutterSecureStorage", Context.MODE_PRIVATE)
            val rawValue = preferences.getString(ELEMENT_PREFERENCES_KEY_PREFIX + "_" + key, null)
            return  decodeRawValue(appContext, rawValue)
        }

        @Throws(java.lang.Exception::class)
        private fun decodeRawValue(appContext: Context, value: String?): String? {
            if (value == null) {
                return null
            }
            var charset = Charset.forName("UTF-8");
            val data: ByteArray = Base64.decode(value, 0)
            var keyCipherAlgo = RSACipher18Implementation(context = appContext)
            var storageCipher = StorageCipher18Implementation(appContext, keyCipherAlgo)
            val result: ByteArray = storageCipher.decrypt(data)
            return String(result, charset)
        }
    }
}