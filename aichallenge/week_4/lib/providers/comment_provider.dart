import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/comment.dart';
import '../repositories/comment_repository.dart';


// Provider untuk membuat instance Dio.
//
// Dengan provider ini, Dio dapat digunakan kembali
// oleh repository dan lebih mudah diganti saat testing.
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});


// Provider untuk membuat CommentRepository.
//
// Repository mengambil Dio dari dioProvider.
final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return CommentRepository(dio);
});


// AsyncNotifier digunakan untuk mengatur state asynchronous.
//
// State yang mungkin terjadi:
//
// AsyncLoading()
// AsyncData<List<Comment>>()
// AsyncError()
class CommentNotifier extends AsyncNotifier<List<Comment>> {
  // build() menentukan state awal provider.
  //
  // Pada awalnya belum ada request sehingga state
  // berada dalam kondisi loading.
  @override
  Future<List<Comment>> build() async {
    return [];
  }

  // Method untuk mengambil komentar berdasarkan postId.
  Future<void> fetchComments(int postId) async {
    // Mengubah state menjadi loading ketika request dimulai.
    state = const AsyncLoading();

    try {
      // Mengambil repository dari Riverpod.
      final repository = ref.read(commentRepositoryProvider);

      // Memanggil API melalui repository.
      final comments = await repository.fetchComments(postId);

      // Jika berhasil, simpan data sebagai AsyncData.
      state = AsyncData(comments);
    } on DioException catch (e, stackTrace) {
      // Jika terjadi DioException, ubah menjadi pesan
      // yang lebih ramah untuk pengguna.
      state = AsyncError(
        _getFriendlyErrorMessage(e),
        stackTrace,
      );
    } catch (e, stackTrace) {
      // Menangani error lain yang tidak berasal dari Dio.
      state = AsyncError(
        'Terjadi kesalahan yang tidak diketahui.',
        stackTrace,
      );
    }
  }

  // Mengubah DioException menjadi pesan yang
  // dapat dipahami pengguna.
  String _getFriendlyErrorMessage(DioException error) {
    // Error karena request terlalu lama.
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Koneksi terlalu lama. Silakan coba lagi.';
    }

    // Error ketika tidak dapat terhubung ke server.
    if (error.type == DioExceptionType.connectionError) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
    }

    // Mengambil status code jika server memberikan response.
    final statusCode = error.response?.statusCode;

    // Resource tidak ditemukan.
    if (statusCode == 404) {
      return 'Data yang diminta tidak ditemukan.';
    }

    // Internal Server Error.
    if (statusCode == 500) {
      return 'Server sedang mengalami masalah. Silakan coba lagi nanti.';
    }

    // Pesan default untuk error lain.
    return 'Terjadi kesalahan saat mengambil data.';
  }
}


// Provider utama untuk CommentNotifier.
//
// UI dapat menggunakan provider ini untuk membaca
// AsyncValue<List<Comment>>.
final commentProvider =
    AsyncNotifierProvider<CommentNotifier, List<Comment>>(
  CommentNotifier.new,
);