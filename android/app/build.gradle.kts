import java.util.Properties
import java.io.FileInputStream
import java.io.File

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")

    id("com.google.gms.google-services") // package (firebase, awesome_notifications, google_maps_flutter)
    id("com.google.firebase.crashlytics") // package (firebase)
}

// Set Build release
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
 }
 // Set Build release

// load settings from local.properties
val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { localProperties.load(it) }
}
// load settings from local.properties


// val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toIntOrNull() ?: 108
// val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0.8"

android {
    namespace = "com.saksiamleasing.sakcamera"
    compileSdk = 36
    //ndkVersion = flutter.compilendkVersion
    ndkVersion = "27.0.12077973" // version ndk.

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    // kotlin version >= 35
    sourceSets {
        sourceSets["main"].java.srcDirs("src/main/kotlin")
    }
    // kotlin version >= 35

    defaultConfig {
        applicationId = "com.saksiamleasing.sakcamera"

        // camera.
        minSdk = 24
        // camera.
        
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // versionCode = 16
        // versionName = "1.2.8"

        // kotlin version >= 35
        ndk {
            debugSymbolLevel = "FULL"
        }
        // kotlin version >= 35
    }

    // Set Build release
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.toString()?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    // Set Build release

    buildTypes {
        // Set Build release
        release {
            signingConfig = signingConfigs.getByName("release")
        }
        // Set Build release
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    dependencies {
    implementation("com.google.android.material:material:1.12.0")
    }

}

flutter {
    source = "../.."
}

dependencies {
    // package (flutter_local_notifications)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5") // java jdk
    implementation("androidx.window:window:1.0.0")
    implementation("androidx.window:window-java:1.0.0")
    // package (flutter_local_notifications)
        // kotlin version >= 35
    // implementation ("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0")
    // kotlin version >= 35
    implementation(platform("com.google.firebase:firebase-bom:34.6.0")) // package (firebase)
    implementation("com.google.firebase:firebase-analytics") // package (firebase)
    // implementation("com.google.firebase:firebase-analytics-ktx") // package (firebase analytics)
    // implementation("com.google.firebase:firebase-iid:21.1.0") // package (firebase)
    implementation ("org.jetbrains.kotlin:kotlin-stdlib-jdk8:2.1.0") // package (camerawesome, qr_code_scanner_plus, photo_manager, qr_code_scanner)
    implementation ("com.google.android.material:material:1.13.0") // package (flutter_native_splash)
    // package (flutter_native_splash)
    // implementation "androidx.core:core-splashscreen:1.0.0"
    // package (flutter_native_splash)
    implementation ("com.google.android.gms:play-services-location:21.3.0") // package (geolocator, location)
    implementation("com.google.firebase:firebase-crashlytics") // package (firebase)
    // implementation ("androidx.room:room:2.8.3") // package (floor)
    // implementation ("androidx.room:room-ktx:2.8.3") // package (floor)
    // implementation ("androidx.room:room-runtime:2.8.3") // package (floor)
    // implementation ("com.google.android.gms:play-services-maps:19.2.0") // package (google_maps_flutter)
    // play integrity api
    implementation("com.google.android.play:integrity:1.4.0")
    // play integrity api
    implementation("androidx.multidex:multidex:2.0.1") // kotlin version >= 35
}