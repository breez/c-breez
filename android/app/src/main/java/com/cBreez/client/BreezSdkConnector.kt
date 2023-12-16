package com.cBreez.client

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import breez_sdk.*
import io.flutter.util.PathUtils

class BreezSdkConnector() {

    companion object {
        private const val TAG = "BreezSdkConnector"
        private var breezSDK: BlockingBreezServices? = null

        internal fun connectSDK(applicationContext: Context): BlockingBreezServices {
            synchronized(this) {
                if (breezSDK == null) {
                    Log.i(TAG, "Connecting to Breez SDK")
                    // Select your seed, invite code and environment
                    // TODO(_): Read mnemonic from Keystore
                    val mnemonic = ""
                    val seed = mnemonicToSeed(mnemonic)
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
    }
//
//    @Throws(java.lang.Exception::class)
//    private fun readSecuredValued(preferences: SharedPreferences, key: String?): String? {
//        val rawValue = preferences.getString(key, null)
//        return decodeRawValue(rawValue)
//    }
//
//    @Throws(java.lang.Exception::class)
//    private fun decodeRawValue(value: String?): String? {
//        if (value == null) {
//            return null
//        }
//        var charset = Charset.forName("UTF-8");
//        val data: ByteArray = Base64.decode(value, 0)
//
//        var d = RSACipher18Implementation(context = this.appContext)
//
//        val result: ByteArray = storageCipher.decrypt(data)
//        return String(result, charset)
//    }

}