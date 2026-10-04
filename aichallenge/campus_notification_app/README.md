# Campus Notification App

## Setup
1. `flutter create . --org id.ac.kampus --project-name campus_notification_app`
   (membuat folder android/ & ios/; file lib/ yang sudah ada tidak ditimpa)
2. `dart pub global activate flutterfire_cli && flutterfire configure`
   (membuat `lib/firebase_options.dart`)
3. `flutter pub get`
4. `flutter run --dart-define=API_BASE_URL=https://api.kampus.example`

## Android (13+ / API 33)
`android/app/src/main/AndroidManifest.xml`, di dalam `<manifest>`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```
Di dalam `<application>`:
```xml
<meta-data android:name="com.google.firebase.messaging.default_notification_channel_id"
           android:value="campus_announcement"/>
```
`android/app/build.gradle`: `compileSdk 34+`, dan core library desugaring
(syarat flutter_local_notifications):
```gradle
compileOptions { coreLibraryDesugaringEnabled true }
dependencies { coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4' }
```

## iOS
- Xcode → Runner → Signing & Capabilities: tambah **Push Notifications** dan
  **Background Modes → Remote notifications**.
- Upload APNs Auth Key (.p8) ke Firebase Console → Cloud Messaging.
- Uji di perangkat fisik.

## Peta bagian
- BERBEDA Android 13+ vs iOS: `LocalNotifier.requestAndroidPermission`, channel Android,
  `PushService._requestPermission`, `_registerCurrentToken` (APNs),
  `setForegroundNotificationPresentationOptions`.
- TANPA BuildContext: `PushService`, `LocalNotifier`, `DeviceApi`, `SecureStore`,
  `firebaseMessagingBackgroundHandler` (isolate terpisah).
