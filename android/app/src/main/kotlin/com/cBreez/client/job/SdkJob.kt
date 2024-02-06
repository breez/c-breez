package com.cBreez.client.job

import breez_sdk.BlockingBreezServices
import breez_sdk.EventListener

typealias JobData = MutableMap<String, String>

interface SDKJob : EventListener {
    fun start(breezSDK: BlockingBreezServices)
}
