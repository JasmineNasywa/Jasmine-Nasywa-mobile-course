import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'routes.dart';

// 1. Background handler wajib top-level (di luar kelas manapun)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Jangan akses BuildContext di sini. Cukup catat / simpan ringan saja.
  print("Handling a background message: ${message.messageId}");
}

class FcmService {
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  
  // Variabel buat nyimpen deep link kalau sempat ada
  static String? pendingDeepLink;

  Future<void> initNotification(void Function(String route) go) async {
    // Inisialisasi local notifications untuk foreground banner
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _local.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          go(response.payload!);
        }
      },
    );

    // Daftarkan background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Minta izin notifikasi ke sistem (khusus Android 13+)
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void listenForeground(void Function(String route) go) {
    // Foreground: sistem tidak menampilkan banner otomatis, tampilkan manual via local notification
    FirebaseMessaging.onMessage.listen((message) async {
      final route = message.data['route'] ?? '/';
      const androidDetails = AndroidNotificationDetails(
        'pengumuman', 
        'Pengumuman Kampus',
        importance: Importance.high, 
        priority: Priority.high,
      );
      await _local.show(
        id: message.hashCode,
        title: message.notification?.title ?? 'Pengumuman',
        body: message.notification?.body ?? '',
        notificationDetails: const NotificationDetails(android: androidDetails),
        payload: route,
      );
    });

    // Background -> diklik user
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      go(message.data['route'] ?? '/');
    });
  }

  Future<void> handleTerminated(void Function(String route) go) async {
    // Terminated -> dibuka dari notifikasi awal
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      go(initial.data['route'] ?? '/');
    }
    if (pendingDeepLink != null) {
      go(pendingDeepLink!);
    }
  }


  String routeFromMessage(Map<String, dynamic> data) {
  return data['route'] ?? AppRoutes.home;
}
}