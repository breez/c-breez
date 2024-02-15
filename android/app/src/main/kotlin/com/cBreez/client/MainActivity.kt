package com.cBreez.client

import androidx.lifecycle.lifecycleScope
import breez_sdk.LogEntry
import com.breez.breez_sdk.BreezSDKPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import org.tinylog.kotlin.Logger

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val sdkLogListener = BreezSDKPlugin.Companion.setNodeLogStream()
        sdkLogListener.subscribe(lifecycleScope) { l: LogEntry ->
            when (l.level) {
                "ERROR" -> Logger.tag(TAG).error { l.line }
                "WARN" -> Logger.tag(TAG).warn { l.line }
                "INFO" -> Logger.tag(TAG).info { l.line }
                "DEBUG" -> Logger.tag(TAG).debug { l.line }
                //"TRACE" -> Logger.tag(TAG).trace { l.line }
            }
        }
    }

    companion object {
        private const val TAG = "Greenlight"
    }
}