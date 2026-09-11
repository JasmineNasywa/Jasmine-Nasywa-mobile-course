import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:week_3/pages/stats_page.dart';

void main() {
  test(
    'StatsNotifier berhasil mengambil data statistik',
    () async {
      final container = ProviderContainer();

      addTearDown(container.dispose);

      final result = await container.read(statsProvider.future);

      expect(result, [
        'Total Pengguna: 1.250',
        'Pengguna Aktif: 875',
        'Pendapatan: Rp12.500.000',
      ]);
    },
  );
}