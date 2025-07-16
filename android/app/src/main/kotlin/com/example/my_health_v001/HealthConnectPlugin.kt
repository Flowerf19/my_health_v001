package com.example.my_health_v001

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.activity.result.contract.ActivityResultContracts
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.StepsRecord
import androidx.health.connect.client.records.HeartRateRecord
import androidx.health.connect.client.records.SleepSessionRecord
import androidx.health.connect.client.records.Record
import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.time.TimeRangeFilter
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.time.Instant
import java.time.temporal.ChronoUnit
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import android.util.Log
import kotlin.reflect.KClass

class HealthConnectPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var healthConnectClient: HealthConnectClient
    private val coroutineScope = CoroutineScope(Dispatchers.Main)
    private val TAG = "HealthConnectPlugin"

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "health_connect")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        
        try {
            Log.d(TAG, "Initializing Health Connect client...")
            healthConnectClient = HealthConnectClient.getOrCreate(context)
            Log.d(TAG, "Health Connect client initialized successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Error initializing Health Connect client: ${e.message}")
            e.printStackTrace()
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d(TAG, "Method call received: ${call.method}")
        
        try {
            when (call.method) {
                "isHealthConnectInstalled" -> result.success(isHealthConnectInstalled())
                "isHealthConnectCompatible" -> result.success(isHealthConnectCompatible())
                "openHealthConnectSettings" -> {
                    openHealthConnectSettings()
                    result.success(null)
                }
                "openPlayStore" -> {
                    openPlayStore()
                    result.success(null)
                }
                "requestPermissions" -> requestPermissions(result)
                "getHealthData" -> getHealthData(result)
                "checkPermissions" -> checkPermissions(result)
                else -> {
                    Log.d(TAG, "Method not implemented: ${call.method}")
                    result.notImplemented()
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling method call: ${e.message}")
            e.printStackTrace()
            result.error("METHOD_ERROR", e.message, null)
        }
    }

    private fun isHealthConnectInstalled(): Boolean {
        return try {
            val isInstalled = context.packageManager.getPackageInfo("com.google.android.apps.healthdata", 0) != null
            Log.d(TAG, "Health Connect installed: $isInstalled")
            isInstalled
        } catch (e: PackageManager.NameNotFoundException) {
            Log.d(TAG, "Health Connect not installed: ${e.message}")
            false
        }
    }

    private fun isHealthConnectCompatible(): Boolean {
        val isCompatible = Build.VERSION.SDK_INT >= Build.VERSION_CODES.R
        Log.d(TAG, "Health Connect compatibility check: $isCompatible (API ${Build.VERSION.SDK_INT})")
        return isCompatible
    }

    private fun openHealthConnectSettings() {
        try {
            Log.d(TAG, "Opening Health Connect settings...")
            context.startActivity(Intent().apply {
                action = "androidx.health.ACTION_HEALTH_CONNECT_SETTINGS"
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            })
            Log.d(TAG, "Health Connect settings opened successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Error opening Health Connect settings: ${e.message}")
            e.printStackTrace()
            // Fallback to Play Store if settings can't be opened
            openPlayStore()
        }
    }

    private fun requestPermissions(result: Result) {
        coroutineScope.launch {
            try {
                Log.d(TAG, "Requesting Health Connect permissions...")
                
                // Kiểm tra xem Health Connect đã cài đặt chưa
                if (!isHealthConnectInstalled()) {
                    Log.e(TAG, "Health Connect not installed. Opening Play Store...")
                    openPlayStore()
                    result.error("NOT_INSTALLED", "Health Connect is not installed. Redirecting to Play Store.", null)
                    return@launch
                }

                val permissions = setOf(
                    HealthPermission.getReadPermission(StepsRecord::class),
                    HealthPermission.getWritePermission(StepsRecord::class),
                    HealthPermission.getReadPermission(HeartRateRecord::class),
                    HealthPermission.getWritePermission(HeartRateRecord::class),
                    HealthPermission.getReadPermission(SleepSessionRecord::class),
                    HealthPermission.getWritePermission(SleepSessionRecord::class)
                )

                val granted = healthConnectClient.permissionController.getGrantedPermissions()
                Log.d(TAG, "Currently granted permissions: ${granted.size}/${permissions.size}")
                
                val permissionsArray = permissions.toTypedArray()
                
                // Log all permissions that we're requesting
                Log.d(TAG, "Requesting the following permissions:")
                permissions.forEach { 
                    Log.d(TAG, "  - $it") 
                }
                
                if (granted.containsAll(permissions)) {
                    Log.d(TAG, "All permissions already granted")
                    result.success(mapOf("granted" to true, "requested" to false))
                    return@launch
                }

                // Sử dụng phương thức chuẩn để yêu cầu quyền
                try {
                    Log.d(TAG, "Launching Health Connect permission request...")
                    
                    // Phương thức 1: Sử dụng Intent trực tiếp
                    val intent = Intent("android.health.PERMISSIONS_REQUEST").apply {
                        putExtra("android.health.permission.PERMISSIONS", permissionsArray)
                        setPackage("com.google.android.apps.healthdata")
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    }
                    
                    // Log để debug
                    Log.d(TAG, "Intent created with:")
                    Log.d(TAG, "  - Action: ${intent.action}")
                    Log.d(TAG, "  - Package: ${intent.`package`}")
                    Log.d(TAG, "  - Permission array size: ${permissionsArray.size}")
                    
                    context.startActivity(intent)
                    
                    Log.d(TAG, "Permission request launched successfully")
                    result.success(mapOf("granted" to false, "requested" to true))
                } catch (e: Exception) {
                    Log.e(TAG, "Error launching Health Connect permission request: ${e.message}")
                    e.printStackTrace()
                    
                    try {
                        // Phương thức 2: Sử dụng Intent khác
                        Log.d(TAG, "Trying alternate method for requesting permissions...")
                        val alternateIntent = Intent("androidx.health.ACTION_REQUEST_PERMISSIONS").apply {
                            putExtra("android.health.permission.PERMISSIONS", permissionsArray)
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        }
                        context.startActivity(alternateIntent)
                        result.success(mapOf("granted" to false, "requested" to true, "alternateMethod" to true))
                    } catch (e2: Exception) {
                        Log.e(TAG, "Error with alternate method: ${e2.message}")
                        
                        try {
                            // Fallback: Mở cài đặt Health Connect trực tiếp
                            Log.d(TAG, "Fallback: Opening Health Connect settings...")
                            openHealthConnectSettings()
                            result.success(mapOf("granted" to false, "requested" to true, "fallback" to true))
                        } catch (e3: Exception) {
                            Log.e(TAG, "Error opening Health Connect settings: ${e3.message}")
                            result.error("PERMISSION_REQUEST_ERROR", 
                                "Failed to request permissions and open settings", null)
                        }
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error in requestPermissions: ${e.message}")
                e.printStackTrace()
                result.error("PERMISSION_ERROR", e.message, null)
            }
        }
    }
    
    private fun openPlayStore() {
        try {
            val intent = Intent(Intent.ACTION_VIEW).apply {
                data = android.net.Uri.parse("market://details?id=com.google.android.apps.healthdata")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
        } catch (e: Exception) {
            Log.e(TAG, "Could not open Play Store: ${e.message}")
            // Fallback to browser
            val webIntent = Intent(Intent.ACTION_VIEW).apply {
                data = android.net.Uri.parse("https://play.google.com/store/apps/details?id=com.google.android.apps.healthdata")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(webIntent)
        }
    }

    private fun getHealthData(result: Result) {
        coroutineScope.launch {
            try {
                Log.d(TAG, "Starting to fetch health data...")
                if (!isHealthConnectInstalled()) {
                    Log.e(TAG, "Health Connect is not installed")
                    result.error("NOT_INSTALLED", "Health Connect is not installed. Please install Health Connect from Google Play Store", null)
                    return@launch
                }

                // Kiểm tra quyền trước khi truy cập dữ liệu
                val permissions = setOf(
                    HealthPermission.getReadPermission(StepsRecord::class),
                    HealthPermission.getReadPermission(HeartRateRecord::class),
                    HealthPermission.getReadPermission(SleepSessionRecord::class)
                )
                
                val granted = healthConnectClient.permissionController.getGrantedPermissions()
                if (!granted.containsAll(permissions)) {
                    Log.e(TAG, "Permissions not granted: ${granted.size}/${permissions.size}")
                    result.error("PERMISSION_DENIED", "Required permissions not granted. Please grant access to health data first.", null)
                    return@launch
                }
                
                Log.d(TAG, "All permissions granted, fetching health data...")

                // Mở rộng khoảng thời gian lấy dữ liệu (60 ngày thay vì 7 ngày)
                val endTime = Instant.now()
                val startTime = endTime.minus(60, ChronoUnit.DAYS)
                val timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
                val healthData = mutableMapOf<String, Any>()

                // Kiểm tra trước xem có dữ liệu không
                val hasStepsData = hasAvailableData(StepsRecord::class, startTime, endTime)
                val hasHeartRateData = hasAvailableData(HeartRateRecord::class, startTime, endTime)
                val hasSleepData = hasAvailableData(SleepSessionRecord::class, startTime, endTime)
                
                Log.d(TAG, "Data availability: Steps=$hasStepsData, HeartRate=$hasHeartRateData, Sleep=$hasSleepData")

                try {
                    // Read Steps
                    Log.d(TAG, "Reading steps data...")
                    val stepsResponse = withContext(Dispatchers.IO) {
                        try {
                            healthConnectClient.readRecords(
                                ReadRecordsRequest(
                                    recordType = StepsRecord::class,
                                    timeRangeFilter = timeRangeFilter
                                )
                            )
                        } catch (e: Exception) {
                            Log.e(TAG, "Error reading steps data: ${e.message}")
                            null
                        }
                    }
                    
                    val totalSteps = stepsResponse?.records?.sumOf { it.count } ?: 0
                    Log.d(TAG, "Total steps found: $totalSteps from ${stepsResponse?.records?.size ?: 0} records")
                    healthData["steps"] = totalSteps
                    
                    // Lưu thêm dữ liệu step theo từng ngày
                    val dailySteps = mutableMapOf<String, Int>()
                    stepsResponse?.records?.forEach { record ->
                        val date = record.startTime.toString().split("T")[0] // Lấy phần ngày YYYY-MM-DD
                        val currentSteps = dailySteps[date] ?: 0
                        dailySteps[date] = currentSteps + record.count.toInt()
                        Log.d(TAG, "Found ${record.count} steps for date $date")
                    }
                    
                    if (dailySteps.isNotEmpty()) {
                        healthData["daily_steps"] = dailySteps
                        Log.d(TAG, "Daily steps data for ${dailySteps.size} days")
                    } else {
                        Log.w(TAG, "No daily steps data found in the time range")
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error processing steps data: ${e.message}")
                    Log.e(TAG, "Stack trace: ${e.stackTraceToString()}")
                    healthData["steps"] = 0
                    healthData["steps_error"] = e.message ?: "Unknown error"
                }

                try {
                    // Read Heart Rate
                    Log.d(TAG, "Reading heart rate data...")
                    val heartRateResponse = withContext(Dispatchers.IO) {
                        try {
                            healthConnectClient.readRecords(
                                ReadRecordsRequest(
                                    recordType = HeartRateRecord::class,
                                    timeRangeFilter = timeRangeFilter
                                )
                            )
                        } catch (e: Exception) {
                            Log.e(TAG, "Error reading heart rate data: ${e.message}")
                            null
                        }
                    }
                    
                    if (heartRateResponse != null && heartRateResponse.records.isNotEmpty()) {
                        val samples = heartRateResponse.records.flatMap { it.samples }
                        Log.d(TAG, "Heart rate samples found: ${samples.size} from ${heartRateResponse.records.size} records")
                        
                        if (samples.isNotEmpty()) {
                            val rates = samples.map { it.beatsPerMinute }
                            
                            // In ra một số mẫu để debug
                            samples.take(5).forEach { sample ->
                                Log.d(TAG, "Heart rate sample: ${sample.beatsPerMinute} BPM at ${sample.time}")
                            }
                            
                            // Tạo map lưu nhịp tim theo ngày
                            val dailyHeartRates = mutableMapOf<String, List<Map<String, Any>>>()
                            samples.forEach { sample ->
                                val date = sample.time.toString().split("T")[0]
                                val entry = mapOf(
                                    "bpm" to sample.beatsPerMinute,
                                    "time" to sample.time.toString()
                                )
                                val currentList = dailyHeartRates[date] ?: listOf()
                                dailyHeartRates[date] = currentList + entry
                            }
                            
                            healthData["heart_rate"] = mapOf(
                                "average" to rates.average(),
                                "min" to (rates.minOrNull() ?: 0),
                                "max" to (rates.maxOrNull() ?: 0),
                                "records" to samples.map { 
                                    mapOf(
                                        "bpm" to it.beatsPerMinute,
                                        "timestamp" to it.time.toString()
                                    )
                                },
                                "daily" to dailyHeartRates
                            )
                            
                            Log.d(TAG, "Processed heart rate data - avg: ${rates.average()}, records: ${samples.size}")
                        } else {
                            Log.d(TAG, "No heart rate values found")
                            healthData["heart_rate"] = emptyMap<String, Any>()
                            healthData["heart_rate_error"] = "No heart rate samples found in records"
                        }
                    } else {
                        Log.d(TAG, "No heart rate records found")
                        healthData["heart_rate"] = emptyMap<String, Any>()
                        healthData["heart_rate_error"] = "No heart rate records found"
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error processing heart rate data: ${e.message}")
                    Log.e(TAG, "Stack trace: ${e.stackTraceToString()}")
                    healthData["heart_rate"] = emptyMap<String, Any>()
                    healthData["heart_rate_error"] = e.message ?: "Unknown error"
                }

                try {
                    // Read Sleep Data
                    Log.d(TAG, "Reading sleep data...")
                    val sleepResponse = withContext(Dispatchers.IO) {
                        try {
                            healthConnectClient.readRecords(
                                ReadRecordsRequest(
                                    recordType = SleepSessionRecord::class,
                                    timeRangeFilter = timeRangeFilter
                                )
                            )
                        } catch (e: Exception) {
                            Log.e(TAG, "Error reading sleep data: ${e.message}")
                            null
                        }
                    }
                    
                    if (sleepResponse != null && sleepResponse.records.isNotEmpty()) {
                        val totalMinutes = sleepResponse.records.sumOf { 
                            ChronoUnit.MINUTES.between(it.startTime, it.endTime) 
                        }
                        Log.d(TAG, "Sleep sessions found: ${sleepResponse.records.size}, total minutes: $totalMinutes")
                        
                        // In ra một số mẫu để debug
                        sleepResponse.records.take(3).forEach { session ->
                            Log.d(TAG, "Sleep session: ${session.startTime} to ${session.endTime}, duration: ${ChronoUnit.MINUTES.between(session.startTime, session.endTime)} minutes")
                        }
                        
                        // Tạo map lưu dữ liệu giấc ngủ theo ngày
                        val dailySleep = mutableMapOf<String, List<Map<String, Any>>>()
                        sleepResponse.records.forEach { session ->
                            val date = session.startTime.toString().split("T")[0]
                            val entry = mapOf(
                                "start" to session.startTime.toString(),
                                "end" to session.endTime.toString(),
                                "duration_minutes" to ChronoUnit.MINUTES.between(session.startTime, session.endTime)
                            )
                            val currentList = dailySleep[date] ?: listOf()
                            dailySleep[date] = currentList + entry
                        }
                        
                        healthData["sleep"] = mapOf(
                            "totalMinutes" to totalMinutes,
                            "sessions" to sleepResponse.records.map {
                                mapOf(
                                    "start" to it.startTime.toString(),
                                    "end" to it.endTime.toString(),
                                    "duration_minutes" to ChronoUnit.MINUTES.between(it.startTime, it.endTime)
                                )
                            },
                            "daily" to dailySleep
                        )
                        
                        Log.d(TAG, "Processed sleep data - ${sleepResponse.records.size} sessions, ${dailySleep.size} days")
                    } else {
                        Log.d(TAG, "No sleep records found")
                        healthData["sleep"] = emptyMap<String, Any>()
                        healthData["sleep_error"] = "No sleep records found"
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error processing sleep data: ${e.message}")
                    Log.e(TAG, "Stack trace: ${e.stackTraceToString()}")
                    healthData["sleep"] = emptyMap<String, Any>()
                    healthData["sleep_error"] = e.message ?: "Unknown error"
                }
                
                // Thêm thông tin chung về dữ liệu sức khỏe
                healthData["lastSync"] = endTime.toString()
                healthData["dataAvailable"] = healthData["steps"] != 0 || 
                                             (healthData["heart_rate"] as? Map<*, *>)?.isNotEmpty() == true ||
                                             (healthData["sleep"] as? Map<*, *>)?.isNotEmpty() == true
                
                // Thêm thông tin debug
                healthData["timeRange"] = mapOf(
                    "start" to startTime.toString(),
                    "end" to endTime.toString(),
                    "daysRange" to ChronoUnit.DAYS.between(startTime, endTime)
                )
                
                healthData["permissionsGranted"] = granted.containsAll(permissions)
                healthData["installedVersion"] = getInstalledVersion()
                
                if (healthData["dataAvailable"] == true) {
                    Log.d(TAG, "Found health data to sync")
                } else {
                    Log.w(TAG, "No health data available to sync")
                }

                Log.d(TAG, "All health data retrieved: ${healthData.keys}")
                result.success(healthData)
            } catch (e: Exception) {
                Log.e(TAG, "General error in getHealthData: ${e.message}")
                e.printStackTrace()
                result.error("HEALTH_DATA_ERROR", "Failed to retrieve health data: ${e.message}", null)
            }
        }
    }
    
    // Thêm hàm kiểm tra dữ liệu có sẵn
    private suspend fun <T : Record> hasAvailableData(
        type: KClass<T>,
        startTime: Instant,
        endTime: Instant
    ): Boolean {
        return try {
            val timeFilter = TimeRangeFilter.between(startTime, endTime)
            val response = withContext(Dispatchers.IO) {
                healthConnectClient.readRecords(
                    ReadRecordsRequest(recordType = type, timeRangeFilter = timeFilter)
                )
            }
            val count = response.records.size
            Log.d(TAG, "Data check for ${type.simpleName}: $count records")
            count > 0
        } catch (e: Exception) {
            Log.e(TAG, "Error checking data for ${type.simpleName}: ${e.message}")
            false
        }
    }

    private fun checkPermissions(result: Result) {
        coroutineScope.launch {
            try {
                Log.d(TAG, "Checking Health Connect permissions...")
                
                val installed = isHealthConnectInstalled()
                Log.d(TAG, "Health Connect installed: $installed")
                
                val compatible = isHealthConnectCompatible()
                Log.d(TAG, "Device compatible: $compatible")
                
                if (!installed) {
                    Log.d(TAG, "Health Connect not installed, returning result")
                    result.success(mapOf(
                        "installed" to false,
                        "compatible" to compatible,
                        "permissionsGranted" to false
                    ))
                    return@launch
                }
                
                val permissions = setOf(
                    HealthPermission.getReadPermission(StepsRecord::class),
                    HealthPermission.getReadPermission(HeartRateRecord::class),
                    HealthPermission.getReadPermission(SleepSessionRecord::class)
                )
                
                val granted = healthConnectClient.permissionController.getGrantedPermissions()
                
                // Log all granted permissions for debugging
                Log.d(TAG, "Granted permissions (${granted.size}):")
                granted.forEach { 
                    Log.d(TAG, "  - $it") 
                }
                
                // Log all requested permissions
                Log.d(TAG, "Requested permissions (${permissions.size}):")
                permissions.forEach { 
                    Log.d(TAG, "  - $it") 
                }
                
                val allGranted = granted.containsAll(permissions)
                Log.d(TAG, "All permissions granted: $allGranted")
                
                result.success(mapOf(
                    "installed" to true,
                    "compatible" to compatible,
                    "permissionsGranted" to allGranted
                ))
            } catch (e: Exception) {
                Log.e(TAG, "Error checking permissions: ${e.message}")
                e.printStackTrace()
                result.error("PERMISSION_CHECK_ERROR", "Failed to check permissions: ${e.message}", null)
            }
        }
    }

    private fun getInstalledVersion(): String {
        return try {
            val packageInfo = context.packageManager.getPackageInfo("com.google.android.apps.healthdata", 0)
            packageInfo.versionName ?: "Unknown"
        } catch (e: Exception) {
            "Unknown"
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}