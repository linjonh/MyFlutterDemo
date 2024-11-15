package com.jaysen.demo.my_flutter_demo

import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val TAG = "MainActivity"
    }

    private val CHANNEL = "com.jaysen/test"

    override fun onCreate(savedInstanceState: Bundle?) {
        // Handle the splash screen transition.
        val splashScreen = installSplashScreen()
        super.onCreate(savedInstanceState)
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
//            // Disable the Android splash screen fade out animation to avoid
//            // a flicker before the similar frame is drawn in Flutter.
//            splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
//        }
        splashScreen.setOnExitAnimationListener { splashScreenViewProvider ->
            Log.d(
                TAG,
                "onCreate: setOnExitAnimationListener: splashScreenViewProvider=${splashScreenViewProvider.iconAnimationDurationMillis}"
            )
            splashScreenViewProvider.remove()
        }
    }

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
