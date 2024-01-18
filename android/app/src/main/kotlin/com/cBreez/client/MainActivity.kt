package com.cBreez.client

import com.cBreez.client.BreezSdkConnector.Companion.setNodeLogStream
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        // Set node log stream
        activity.runOnUiThread {
            val eventChannel =
                EventChannel(flutterEngine.dartExecutor.binaryMessenger, "breez_sdk_node_logs")
            setNodeLogStream()
            eventChannel.setStreamHandler(NodeLogHandler())
        }
    }
}