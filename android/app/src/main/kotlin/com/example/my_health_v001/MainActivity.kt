package com.example.my_health_v001

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import android.os.Bundle
import android.util.Log

class MainActivity : FlutterActivity() {
    private val TAG = "MainActivity"
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Log để debug
        Log.d(TAG, "Health Connect app integration starting...")
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        try {
            // Đăng ký plugin Health Connect
            flutterEngine.plugins.add(HealthConnectPlugin())
            GeneratedPluginRegistrant.registerWith(flutterEngine)
            Log.d(TAG, "Health Connect plugin registered successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Error registering Health Connect plugin: ${e.message}")
            e.printStackTrace()
        }
    }
}
