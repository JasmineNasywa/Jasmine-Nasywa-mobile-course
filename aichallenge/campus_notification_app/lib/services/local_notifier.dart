import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Pembungkus flutter_local_notifications.
/// [TANPA BuildContext] — dipakai juga dari background isolate.
class LocalNotifier {
  LocalNotifier._();
  static final instance = LocalNotifier._();

  final _plugin = FlutterLocalNotificationsPlugin();

  // [ANDROID] Channel wajib sejak Android 8.0.
  static const channel = AndroidNotificationChannel(
    'campus_announcement',
    'Pengumuman Kampus',
    description: 'Notifikasi pengumuman kampus',
    importance: Importance.high,
  );

  Future<void> init({void Function(String? payload)? onTap}) async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      // [iOS] izin diminta lewat FirebaseMessaging.requestPermission,
      // jadi di sini dimatikan agar tidak muncul dialog dua kali.
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(
      settings,
      // Klik local notification saat app foreground/background.
      onDidReceiveNotificationResponse: (r) => onTap?.call(r.payload),
    );
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// [ANDROID 13+ / API 33] POST_NOTIFICATIONS adalah izin runtime.
  /// Di Android <13 tidak ada dialog. Tidak dipakai di iOS.
  Future<bool> requestAndroidPermission() async {
    if (!Platform.isAndroid) return true;
    final granted = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    return granted ?? true;
  }

  /// Untuk kasus app terminated lalu dibuka dari local notification.
  Future<NotificationAppLaunchDetails?> launchDetails() =>
      _plugin.getNotificationAppLaunchDetails();

  Future<void> showFromMessage(RemoteMessage m) async {
    final title = m.notification?.title ?? m.data['title'] as String?;
    final body = m.notification?.body ?? m.data['body'] as String?;
    await _plugin.show(
      (m.messageId ?? DateTime.now().toIso8601String()).hashCode & 0x7fffffff,
      title ?? 'Pengumuman Kampus',
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: m.data['route'] as String?, // route dibawa lewat payload
    );
  }
}
