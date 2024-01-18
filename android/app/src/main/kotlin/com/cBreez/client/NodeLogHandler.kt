package com.cBreez.client

import io.flutter.plugin.common.EventChannel
import org.tinylog.kotlin.Logger

class NodeLogHandler : EventChannel.StreamHandler {
    companion object {
        var eventSink: EventChannel.EventSink? = null
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        Logger.tag("NodeLogHandler")
            .info { "${Thread.currentThread().name} onListen arguments：$arguments" }
        Logger.tag("NodeLogHandler").info { "onListen eventSink：$eventSink" }
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        Logger.tag("NodeLogHandler").info { "${Thread.currentThread().name} onCancel：$arguments" }
    }
}