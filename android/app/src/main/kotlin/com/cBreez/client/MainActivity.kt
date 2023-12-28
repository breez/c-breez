package com.cBreez.client

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.os.PersistableBundle
import androidx.annotation.RequiresApi
import androidx.lifecycle.MutableLiveData
import com.cBreez.client.BreezNotificationHelper.Companion.registerNotificationChannels
import io.flutter.embedding.android.FlutterActivity
import org.tinylog.kotlin.Logger

class MainActivity : FlutterActivity() {
    private val _service = MutableLiveData<BreezForegroundService?>(null)

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        registerNotificationChannels(applicationContext)
    }

    override fun onStart() {
        super.onStart()
        Intent(this, BreezForegroundService::class.java).let { intent ->
            applicationContext.bindService(
                intent,
                serviceConnection,
                Context.BIND_AUTO_CREATE or Context.BIND_ADJUST_WITH_ACTIVITY
            )
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            unbindService(serviceConnection)
        } catch (e: Exception) {
            Logger.error { "Failed to unbind activity from node service: ${e.localizedMessage}" }
        }
        Logger.debug { "Destroyed main activity" }
    }

    private val serviceConnection = object : ServiceConnection {
        override fun onServiceConnected(component: ComponentName, bind: IBinder) {
            Logger.debug { "Connected to BreezForegroundService" }
            _service.value = (bind as BreezForegroundService.BreezNodeBinder).getService()
        }

        override fun onServiceDisconnected(component: ComponentName) {
            Logger.debug { "Disconnected from BreezForegroundService" }
            _service.postValue(null)
        }
    }
}