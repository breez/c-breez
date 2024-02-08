package com.cBreez.client.job

import breez_sdk.BlockingBreezServices
import breez_sdk.EventListener

interface SDKJob : EventListener {
    fun start(breezSDK: BlockingBreezServices)
}
