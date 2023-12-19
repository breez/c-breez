package com.cBreez.client

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.util.PathUtils
import org.tinylog.kotlin.Logger
import java.io.File

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        configureLogger()
    }

    private fun configureLogger() {
        val loggingDir: File = File(
            PathUtils.getDataDirectory(applicationContext),
            "/logs/android-extension/",
        ).also { it.mkdirs() }

        System.setProperty("tinylog.directory", loggingDir.absolutePath)
        System.setProperty("tinylog.timestamp", System.currentTimeMillis().toString())

        Logger.info { "Starting ${BuildConfig.APPLICATION_ID}..." }
        Logger.info { "Logs directory: '$loggingDir'" }
    }
}
