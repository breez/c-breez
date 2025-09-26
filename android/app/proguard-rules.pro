 # Keep OkHttp classes for UCrop (used by image_cropper)
 -keep class okhttp3.** { *; }
 -dontwarn okhttp3.**
 -keep class com.yalantis.ucrop.** { *; }
 -dontwarn com.yalantis.ucrop.**

 # Tinylog
-keepnames interface org.tinylog.**
-keepnames class * implements org.tinylog.**
-keepclassmembers class * implements org.tinylog.** { <init>(...); }

-dontwarn dalvik.system.VMStack
-dontwarn java.lang.**
-dontwarn javax.naming.**
-dontwarn sun.reflect.Reflection

# JNA
-keep class com.sun.jna.** { *; }
-keep class * implements com.sun.jna.** { *; }

-dontwarn java.awt.**

# Other
-dontoptimize