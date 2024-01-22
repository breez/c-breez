package com.cBreez.client

import androidx.lifecycle.lifecycleScope
import com.breez.breez_sdk.BreezSDKPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import org.tinylog.kotlin.Logger

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val pluginRegistry = flutterEngine.plugins
        val breezSdkPlugin = BreezSDKPlugin()
        val nodeLogStream = breezSdkPlugin.setNodeLogStream()
        nodeLogStream.subscribe(lifecycleScope) { l ->
            when (l.level) {
                "ERROR" -> Logger.tag(TAG).error { l.line }
                "WARN" -> Logger.tag(TAG).warn { l.line }
                "INFO" -> Logger.tag(TAG).info { l.line }
                //"DEBUG" -> Logger.tag(TAG).debug { l.line }
            }
        }
        pluginRegistry.add(breezSdkPlugin)
        //GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    companion object {
        private const val TAG = "Greenlight"
    }
}