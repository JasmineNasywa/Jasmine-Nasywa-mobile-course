import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _local = FlutterLocalNotificationsPlugin();

Future<bool> requestNotificationPermission() async {
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true, 
    badge: true, 
    sound: true,
    announcement: false, 
    carPlay: false, 
    criticalAlert: false,
  );
  return settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional;
}

Future<void> initLocalNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();
  
  await _local.initialize(
    settings: const InitializationSettings(
      android: android,
      iOS: ios,
    ),
    onDidReceiveNotificationResponse: (response) {
    
      pendingDeepLink = response.payload;
    },
  );
}

String? pendingDeepLink;

Future<void> initFcmToken({required Future<void> Function(String token) onToken}) async {
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) await onToken(token);

  FirebaseMessaging.instance.onTokenRefresh.listen(onToken);
  await FirebaseMessaging.instance.subscribeToTopic('pengumuman-kampus');
}

// Contoh manggil izin & inisialisasi token di halaman utama / debug page lu
Future<void> setupNotification() async {
  await requestNotificationPermission();
  await initLocalNotifications();
  
  await initFcmToken(onToken: (token) async {
    // Ambil 12 karakter pertama buat ditampilkan di debug screen
    String maskedToken = '${token.substring(0, 12)}...';
    print('FCM Token (Masked): $maskedToken');

    // Kalau nanti udah ada backend-nya, tinggal di-hit pakai Dio:
    // await dio.post('/devices', data: {'fcm_token': token, 'platform': 'android'});
  });
}