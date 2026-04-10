# Keep Flutter embedding and plugin registration classes.
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Firebase and Crashlytics runtime classes.
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Preserve source/line data for crash symbolication.
-keepattributes SourceFile,LineNumberTable
-keepattributes *Annotation*
