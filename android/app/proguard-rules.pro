# Flutter GetX
-keep class com.getwidgets.** { *; }
-keep class get.** { *; }

# Dio
-keep class com.dio.** { *; }
-dontwarn com.dio.**

# Project Models
-keep class com.brainkets.jewelry.models.** { *; }
-keep class com.brainkets.jewelry.StoreClass { *; }
-keep class com.brainkets.jewelry.CompanySettings { *; }

# Firebase
-keep class com.google.firebase.** { *; }

# Keep all classes that are used by GetX for dependency injection
-keepclassmembers class * extends com.getx.Controller {
    <init>(...);
}

# General Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Play Core (Missing classes in R8)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# If using deferred components / split installs
-keep class io.flutter.app.FlutterPlayStoreSplitApplication { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
