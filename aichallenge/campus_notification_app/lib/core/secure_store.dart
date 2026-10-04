import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Penyimpanan aman (Keychain iOS / EncryptedSharedPreferences Android).
/// [TANPA BuildContext]
class SecureStore {
  const SecureStore();
  static const _s = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _kAuth = 'auth_token';
  static const _kFcm = 'last_fcm_token';
  static const _kSub = 'topic_subscribed';

  Future<String?> readAuthToken() => _s.read(key: _kAuth);
  Future<void> writeAuthToken(String v) => _s.write(key: _kAuth, value: v);

  Future<String?> readFcmToken() => _s.read(key: _kFcm);
  Future<void> writeFcmToken(String v) => _s.write(key: _kFcm, value: v);

  Future<bool> readSubscribed() async => (await _s.read(key: _kSub)) == '1';
  Future<void> writeSubscribed(bool v) =>
      _s.write(key: _kSub, value: v ? '1' : '0');
}

/// Jangan pernah log token penuh.
String maskSecret(String? v) {
  if (v == null || v.isEmpty) return '(kosong)';
  if (v.length <= 10) return '***';
  return '${v.substring(0, 4)}…${v.substring(v.length - 4)}';
}
