# Flutter ProGuard rules

# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Preserve entry points for all Flutter plugins
-keep class com.google.firebase.** { *; }
-keep class com.google.android.** { *; }

# Handle Parcelable classes
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# For file_picker or other libraries
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# General Android rules
-dontwarn javax.annotation.**
-dontwarn org.codehaus.mojo.**
