plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.firebase.appdistribution")
}

android {
    namespace = "com.example.my_health_v002"
    compileSdk = 35

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.my_health_v002"
        minSdk = 30
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Cấu hình Health Connect
        manifestPlaceholders["healthConnectPermissionTypes"] = """
            [
                "androidx.health.permission.Steps.READ",
                "androidx.health.permission.HeartRate.READ",
                "androidx.health.permission.SleepSession.READ"
            ]
        """.trimIndent()
        manifestPlaceholders["healthConnectMinSdkVersion"] = "30"
        
        // Đăng ký ứng dụng với Health Connect
        manifestPlaceholders["healthConnectPackageName"] = "com.google.android.apps.healthdata"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase
    implementation(platform("com.google.firebase:firebase-bom:34.+"))
    implementation("com.google.firebase:firebase-analytics")

    // Health Connect (phiên bản ổn định và có sẵn trong repository)
    implementation("androidx.health.connect:connect-client:1.1.0-alpha11")
    implementation("androidx.health:health-services-client:1.1.0-alpha03")
    implementation("androidx.concurrent:concurrent-futures-ktx:1.+")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.+")

    // Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.+")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.+")

    // AndroidX
    implementation("androidx.core:core-ktx:1.+")
    implementation("androidx.appcompat:appcompat:1.+")
    implementation("com.google.android.material:material:1.+")
    implementation("androidx.constraintlayout:constraintlayout:2.+")
}

configurations.all {
    resolutionStrategy {
        // Chỉ exclude khi thực sự cần thiết
        exclude(group = "androidx.lifecycle", module = "lifecycle-viewmodel-ktx")
    }
}