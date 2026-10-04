import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../firebase_options.dart'; // dihasilkan oleh `flutterfire configure`
import 'local_notifier.dart';

/// ============================================================
/// BACKGROUND HANDLER — WAJIB top-level (bukan method kelas).
/// Berjalan di ISOLATE TERPISAH:
///  - [TANPA BuildContext], tanpa Riverpod `ref`, tanpa GoRouter.
///  - Harus initializeApp sendiri.
/// ============================================================
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Pesan ber-payload `notification` sudah ditampilkan OS (Android & iOS).
  // Hanya pesan data-only yang dibuatkan notifikasi manual (hindari dobel).
  if (message.notification == null) {
    await LocalNotifier.instance.init();
    await LocalNotifier.instance.showFromMessage(message);
  }
}
