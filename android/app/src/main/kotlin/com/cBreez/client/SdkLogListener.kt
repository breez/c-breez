package com.cBreez.client

import android.os.Handler
import android.os.Looper
import breez_sdk.LogEntry
import breez_sdk.LogStream
import com.cBreez.client.NodeLogHandler.Companion.eventSink
import org.tinylog.kotlin.Logger

class SdkLogListener : LogStream {
    // Event has to be handled on main thread.
    private var handler = Handler(Looper.getMainLooper())

    companion object {
        private const val TAG = "Greenlight"
    }

    override fun log(l: LogEntry) {
        when (l.level) {
            "ERROR" -> Logger.tag(TAG).error { l.line }
            "WARN" -> Logger.tag(TAG).warn { l.line }
            "INFO" -> Logger.tag(TAG).info { l.line }
            //"DEBUG" -> Logger.tag(TAG).debug { l.line }
        }

        val runnable = Runnable {
            val data = mapOf("level" to l.level, "line" to l.line)
            eventSink?.success(data)
        }

        handler.post(runnable)
    }
}

