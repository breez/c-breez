package com.cBreez.client

import android.content.Context
import io.flutter.util.PathUtils
import org.tinylog.kotlin.Logger
import java.io.File

class BreezLogger {
    companion object {
        private const val TAG = "BreezLogger"

        private var isInit: Boolean? = null

        internal fun configureLogger(applicationContext: Context): Boolean? {
            synchronized(this) {
                val loggingDir =
                    File(PathUtils.getDataDirectory(applicationContext), "/logs/").apply {
                        mkdirs()
                    }

                System.setProperty("tinylog.directory", loggingDir.absolutePath)
                System.setProperty("tinylog.timestamp", System.currentTimeMillis().toString())

                if (isInit == false) {
                    Logger.tag(TAG).debug { "Starting ${BuildConfig.APPLICATION_ID}..." }
                    Logger.tag(TAG).debug { "Logs directory: '$loggingDir'" }
                    isInit = true
                }
                return isInit
            }
        }
    }
}