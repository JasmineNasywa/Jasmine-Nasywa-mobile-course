import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsNotifier extends AsyncNotifier<List<String>> {
  StatsNotifier({Random? random}) : _random = random ?? Random();

  final Random _random;

  @override
  Future<List<String>> build() async {
    await Future.delayed(const Duration(seconds: 2));

    if (_random.nextDouble() < 0.3) {
      throw Exception('Gagal mengambil data statistik');
    }

    return [
      'Total Pengguna: 1.250',
      'Pengguna Aktif: 875',
      'Pendapatan: Rp12.500.000',
    ];
  }
}

final statsProvider =
    AsyncNotifierProvider<StatsNotifier, List<String>>(
  StatsNotifier.new,
);