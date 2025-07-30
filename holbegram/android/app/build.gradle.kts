plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // ✅ ضروري لـ Firebase
    id("dev.flutter.flutter-gradle-plugin") // ✅ تأكد أنه الأخير كما هو
}

android {
    namespace = "com.example.holbegram"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.holbegram" // ✅ يجب أن يطابق اسم الحزمة في Firebase
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
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
    // ✅ منصة Firebase لإدارة الإصدارات
    implementation(platform("com.google.firebase:firebase-bom:30.2.0"))

    // ✅ Firebase Auth - لتسجيل الدخول
    implementation("com.google.firebase:firebase-auth")

    // ✅ Firestore - قاعدة البيانات (يمكنك إزالتها لو لا تحتاجها الآن)
    implementation("com.google.firebase:firebase-firestore")

    // ✅ Cloud Storage - لتخزين الصور (لاحقًا)
    implementation("com.google.firebase:firebase-storage")
}
