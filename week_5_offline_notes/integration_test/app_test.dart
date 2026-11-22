import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';

import 'package:week_5_offline_notes/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Offline Notes Integration Test', () {
    testWidgets('user can create and view a note', (tester) async {
      // 1. Jalankan aplikasi
      app.main();
      await tester.pumpAndSettle();

      // 2. Pastikan halaman utama tampil
      expect(find.text('Notes'), findsOneWidget);

      // 3. Buka halaman tambah catatan
      // TODO: sesuaikan dengan tombol navigasi di aplikasi

      // 4. Isi judul dan isi catatan
      // TODO: sesuaikan dengan widget TextField

      // 5. Simpan catatan
      // TODO: sesuaikan dengan tombol save

      // 6. Pastikan catatan muncul di halaman utama
      // TODO: sesuaikan dengan tampilan daftar catatan
    });
  });
}