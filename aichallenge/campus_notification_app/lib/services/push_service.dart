import 'dart:async';
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../core/config.dart';
import '../core/secure_store.dart';
import 'device_api.dart';
import 'local_notifier.dart';

/// PushService
/// [TANPA BuildContext] — class ini tidak menerima/menyimpan BuildContext.
/// Navigasi memakai instance GoRouter (di-inject lewat Riverpod).
class PushService {
  PushService({
    required GoRouter router,
    required DeviceApi api,
    required SecureStore store,
  })  : _router = router,
        _api = api,
        _store = store;

  final GoRouter _router;
  final DeviceApi _api;
  final SecureStore _store;
  final _fcm = FirebaseMessaging.instance;
  final _subs = <StreamSubscription>[];

  /// Panggil sekali, setelah app ter-render (post-frame di root widget).
  Future<void> init() async {
    await LocalNotifier.instance.init(onTap: _navigate);

    await _requestPermission();

    // [iOS] Saat foreground, jangan tampilkan banner sistem
    // (kita tampilkan local notification manual agar tidak dobel).
    // Android tidak menampilkan notifikasi FCM saat foreground sama sekali.
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: false,
    );

    await _registerCurrentToken();

    // Token berubah -> kirim ulang ke backend.
    _subs.add(_fcm.onTokenRefresh.listen(
      _sendToken,
      onError: (e) => debugPrint('[Push] onTokenRefresh error: $e'),
    ));

    // FOREGROUND: tampilkan local notification manual.
    _subs.add(FirebaseMessaging.onMessage.listen(_onForeground));

    // BACKGROUND (app hidup di latar): klik notifikasi sistem.
    _subs.add(FirebaseMessaging.onMessageOpenedApp
        .listen((m) => _navigate(m.data['route'] as String?)));

    // TERMINATED: app dibuka dari klik notifikasi sistem.
    final initial = await _fcm.getInitialMessage();
    if (initial != null) _navigate(initial.data['route'] as String?);

    // TERMINATED: app dibuka dari klik LOCAL notification.
    final launch = await LocalNotifier.instance.launchDetails();
    if (launch?.didNotificationLaunchApp == true) {
      _navigate(launch!.notificationResponse?.payload);
    }
  }

  // ---------------------------------------------------------------
  // Izin
  // ---------------------------------------------------------------
  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      // [ANDROID 13+] dialog runtime POST_NOTIFICATIONS.
      // Manifest juga harus mendeklarasikan izin ini (lihat README).
      final ok = await LocalNotifier.instance.requestAndroidPermission();
      debugPrint('[Push] Android POST_NOTIFICATIONS granted=$ok');
    } else {
      // [iOS] dialog izin alert/badge/sound.
      final s = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      debugPrint('[Push] iOS authorization=${s.authorizationStatus}');
    }
  }

  // ---------------------------------------------------------------
  // Token
  // ---------------------------------------------------------------
  Future<void> _registerCurrentToken() async {
    if (Platform.isIOS) {
      // [iOS] FCM token baru tersedia setelah APNs token ada.
      String? apns;
      for (var i = 0; i < 5 && apns == null; i++) {
        apns = await _fcm.getAPNSToken();
        if (apns == null) await Future.delayed(const Duration(seconds: 1));
      }
      if (apns == null) debugPrint('[Push] APNs token belum tersedia.');
    }
    final token = await _fcm.getToken();
    if (token != null) await _sendToken(token);
  }

  Future<void> _sendToken(String token) async {
    final ok = await _api.registerDevice(token); // POST /devices
    if (ok) await _store.writeFcmToken(token);
    debugPrint('[Push] token ${maskSecret(token)} terkirim=$ok');
  }

  // ---------------------------------------------------------------
  // Topic
  // ---------------------------------------------------------------
  Future<void> subscribeAnnouncements() async {
    await _fcm.subscribeToTopic(Config.topicAnnouncement);
    await _store.writeSubscribed(true);
  }

  Future<void> unsubscribeAnnouncements() async {
    await _fcm.unsubscribeFromTopic(Config.topicAnnouncement);
    await _store.writeSubscribed(false);
  }

  // ---------------------------------------------------------------
  // Pesan
  // ---------------------------------------------------------------
  Future<void> _onForeground(RemoteMessage m) =>
      LocalNotifier.instance.showFromMessage(m);

  /// Navigasi dari data.route, divalidasi agar payload luar tidak bisa
  /// mengarahkan ke rute sembarang.
  void _navigate(String? route) {
    if (route == null || route.isEmpty) return;
    final ok = route == '/' || route.startsWith('/announcement/');
    if (!ok) {
      debugPrint('[Push] route ditolak: $route');
      return;
    }
    _router.go(route);
  }

  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
  }
}
