import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AsyncNotifier digunakan untuk mengelola data statistik
/// yang proses pengambilannya bersifat asynchronous.
class StatsNotifier extends AsyncNotifier<List<String>> {
  /// Random digunakan untuk mensimulasikan kemungkinan request gagal.
  final Random _random = Random();

  /// build() dijalankan ketika provider pertama kali digunakan.
  /// Hasilnya berupa Future yang menghasilkan List<String>.
  @override
  Future<List<String>> build() async {
    // Simulasi waktu pengambilan data selama 2 detik.
    await Future.delayed(const Duration(seconds: 2));

    // Simulasi kemungkinan gagal sebesar 30%.
    if (_random.nextDouble() < 0.3) {
      throw Exception('Gagal mengambil data statistik');
    }

    // Data statistik jika pengambilan berhasil.
    return [
      'Total Pengguna: 1.250',
      'Pengguna Aktif: 875',
      'Pendapatan: Rp12.500.000',
    ];
  }
}

/// Provider yang menghubungkan StatsNotifier dengan UI.
final statsProvider =
    AsyncNotifierProvider<StatsNotifier, List<String>>(
  StatsNotifier.new,
);

/// ConsumerWidget digunakan karena halaman perlu membaca
/// dan mendengarkan perubahan state dari Riverpod.
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch membuat UI otomatis rebuild ketika state provider berubah.
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),

      // when() digunakan untuk menangani tiga kemungkinan state:
      // loading, error, dan data/success.
      body: statsAsync.when(
        // Tampilan ketika data masih diambil.
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        // Tampilan ketika pengambilan data gagal.
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Gagal memuat data: $error'),

              const SizedBox(height: 12),

              // invalidate membuat provider dijalankan kembali.
              FilledButton(
                onPressed: () {
                  ref.invalidate(statsProvider);
                },
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),

        // Tampilan ketika data berhasil diperoleh.
        data: (stats) => ListView.builder(
          itemCount: stats.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.bar_chart),
              title: Text(stats[index]),
            );
          },
        ),
      ),
    );
  }
}