import java.util.Base64

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}


val dartEnvironmentVariables: Map<String, String> =
    if (project.hasProperty("dart-defines")) {
        (project.property("dart-defines") as String)
            .split(",")
            .map { entry ->
                val pair = String(Base64.getDecoder().decode(entry), Charsets.UTF_8).split("=")
                pair.first() to pair.last()
            }
            .toMap()
    } else {
        emptyMap()
    }


// manifestPlaceholders key
var googleMapsKey: String = "YourGoogleMapApiKey"
if (dartEnvironmentVariables.containsKey("GOOGLE_MAPS_KEY")) {
    googleMapsKey = dartEnvironmentVariables["GOOGLE_MAPS_KEY"]!!
}

android {
    namespace = "com.example.weather_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.weather_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["googleMapsKey"] = googleMapsKey
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
