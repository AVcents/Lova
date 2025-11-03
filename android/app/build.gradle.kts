plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.lova"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }
    kotlinOptions { jvmTarget = "17" }

    defaultConfig {
        applicationId = "com.example.lova"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }
    buildTypes { release { signingConfig = signingConfigs.getByName("debug") } }
}

flutter { source = "../.." }

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    implementation("com.google.firebase:firebase-messaging")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

apply(plugin = "com.google.gms.google-services")
// ============================================
// FIX : Copie l'APK vers le bon dossier
// ============================================
afterEvaluate {
    tasks.named("assembleDebug") {
        doLast {
            copy {
                from("build/outputs/flutter-apk")
                into("../../build/app/outputs/flutter-apk")
            }
        }
    }
}