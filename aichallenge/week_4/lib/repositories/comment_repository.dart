import 'package:dio/dio.dart';

import '../models/comment.dart';

class CommentRepository {
  // Dio digunakan sebagai HTTP client untuk mengambil data
  // dari JSONPlaceholder.
  final Dio dio;

  // Constructor menerima instance Dio.
  // Ini juga membuat repository lebih mudah dites karena
  // instance Dio dapat diganti dengan mock saat testing.
  CommentRepository(this.dio);

  // Method ini mengambil komentar berdasarkan postId.
  Future<List<Comment>> fetchComments(int postId) async {
    try {
      // GET endpoint:
      // https://jsonplaceholder.typicode.com/comments?postId={id}
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/comments',

        // Query parameter akan menghasilkan:
        // ?postId=1
        queryParameters: {
          'postId': postId,
        },

        // Request dibatasi maksimal 10 detik.
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      // Memastikan response memiliki status HTTP yang sukses.
      if (response.statusCode == 200) {
        // Data dari API berupa List.
        final data = response.data as List;

        // Setiap JSON diubah menjadi object Comment
        // menggunakan Comment.fromJson().
        return data
            .map(
              (json) => Comment.fromJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();
      }

      // Jika status bukan 200, lempar exception
      // agar dapat ditangani oleh provider.
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
      );
    } on DioException {
      // DioException diteruskan ke provider.
      // Provider akan mengubahnya menjadi pesan yang
      // lebih mudah dimengerti pengguna.
      rethrow;
    } catch (e) {
      // Error selain DioException juga diteruskan.
      rethrow;
    }
  }
}