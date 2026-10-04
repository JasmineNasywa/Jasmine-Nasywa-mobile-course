import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/config.dart';
import '../core/secure_store.dart';

/// Klien backend. [TANPA BuildContext]
class DeviceApi {
  DeviceApi(this._store);
  final SecureStore _store;

  /// POST /devices -> benar-benar mengirim token ke backend (bukan sekadar print).
  /// Return true jika backend menjawab 2xx.
  Future<bool> registerDevice(String fcmToken) async {
    if (Config.apiBaseUrl.isEmpty) {
      debugPrint('[DeviceApi] API_BASE_URL belum di-set (--dart-define).');
      return false;
    }
    final auth = await _store.readAuthToken();
    try {
      final res = await http
          .post(
            Uri.parse('${Config.apiBaseUrl}/devices'),
            headers: {
              'Content-Type': 'application/json',
              if (auth != null) 'Authorization': 'Bearer $auth',
            },
            body: jsonEncode({
              'token': fcmToken,
              'platform': Platform.isIOS ? 'ios' : 'android',
            }),
          )
          .timeout(const Duration(seconds: 15));
      final ok = res.statusCode >= 200 && res.statusCode < 300;
      debugPrint('[DeviceApi] POST /devices -> ${res.statusCode} '
          '(token ${maskSecret(fcmToken)})');
      return ok;
    } catch (e) {
      debugPrint('[DeviceApi] gagal kirim token: $e');
      return false;
    }
  }
}
