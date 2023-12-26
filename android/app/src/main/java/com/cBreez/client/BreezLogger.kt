package com.cBreez.client

import android.content.Context
import io.flutter.util.PathUtils
import org.tinylog.kotlin.Logger
import java.io.File

class BreezLogger {
    companion object {
        private const val TAG = "BreezLogger"

        private var isInit: Boolean = false

        internal fun configureLogger(applicationContext: Context): Boolean {
            synchronized(this) {
                if (isInit == null) {
                    val loggingDir: File = File(
                        PathUtils.getDataDirectory(applicationContext),
                        "/logs/",
                    ).also { it.mkdirs() }

                    System.setProperty("tinylog.directory", loggingDir.absolutePath)
                    System.setProperty("tinylog.timestamp", System.currentTimeMillis().toString())

                    Logger.tag(TAG).info { "Starting ${BuildConfig.APPLICATION_ID}..." }
                    Logger.tag(TAG).info { "Logs directory: '$loggingDir'" }
                    isInit = true
                }
                return isInit
            }
        }
    }
}