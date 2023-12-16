package com.cBreez.client

import android.content.Context
import android.util.Log
import breez_sdk.BlockingBreezServices
import breez_sdk.EnvironmentType
import breez_sdk.GreenlightNodeConfig
import breez_sdk.NodeConfig
import breez_sdk.Payment
import breez_sdk.connect
import breez_sdk.defaultConfig
import breez_sdk.mnemonicToSeed
import io.flutter.util.PathUtils

class BreezSdkConnector(applicationContext: Context, paymentListener: (payment: Payment) -> Unit) {
    internal var breezSDK: BlockingBreezServices? = null
    private var _applicationContext: Context
    private var _paymentListener: (payment: Payment) -> Unit

    init {
        _paymentListener = paymentListener
        _applicationContext = applicationContext
        connectSDK()
    }

    companion object {
        private const val TAG = "BreezSdkConnector"
    }

    private fun connectSDK(): BlockingBreezServices {
        if (breezSDK == null) {
            Log.i(TAG, "Connecting to Breez SDK")
            // Select your seed, invite code and environment
            // TODO(_): Read mnemonic from Keystore
            val mnemonic = "<your-mnemonic>"
            val seed = mnemonicToSeed(mnemonic)
            val apiKey = _applicationContext.getString(R.string.breezApiKey)

            // Create the default config
            val glNodeConf = GreenlightNodeConfig(null, null)
            val nodeConf = NodeConfig.Greenlight(glNodeConf)
            val config = defaultConfig(EnvironmentType.PRODUCTION, apiKey, nodeConf)
            config.workingDir = PathUtils.getDataDirectory(_applicationContext)
            // Connect to the Breez SDK make it ready for use
            breezSDK = connect(config, seed, SDKListener(_paymentListener))
        }
        return breezSDK as BlockingBreezServices
    }
}