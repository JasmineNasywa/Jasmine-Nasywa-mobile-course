import 'package:flutter_test/flutter_test.dart';

import '../lib/models/comment.dart';

void main() {
  test(
    'Comment.fromJson tetap aman ketika field email dan body hilang',
    () {
      // JSON hanya memiliki sebagian field.
      final json = {
        'postId': 1,
        'id': 1,
        'name': 'John Doe',
      };

      // Mengubah JSON menjadi object Comment.
      final comment = Comment.fromJson(json);

      // Field yang tersedia tetap berhasil dibaca.
      expect(comment.postId, 1);
      expect(comment.id, 1);
      expect(comment.name, 'John Doe');

      // Field yang tidak tersedia seharusnya menjadi null,
      // bukan menyebabkan exception.
      expect(comment.email, isNull);
      expect(comment.body, isNull);
    },
  );
}