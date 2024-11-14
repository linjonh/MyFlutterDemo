package com.jaysen.demo.my_flutter_demo

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val TAG = "MainActivity"
    }

    private val CHANNEL = "com.jaysen/test"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "test" -> {
                    Log.d(TAG, "configureFlutterEngine: ")
                    result.success("test result linjianyou")
                }
            }
        }
    }
}
