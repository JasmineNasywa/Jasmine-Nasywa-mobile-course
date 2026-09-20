class Comment {
  // postId menunjukkan ID post yang memiliki komentar.
  // Dibuat nullable agar aplikasi tetap aman jika field tidak tersedia.
  final int? postId;

  // id adalah ID unik dari komentar.
  final int? id;

  // name berisi nama komentar.
  final String? name;

  // email berisi email pengguna yang membuat komentar.
  final String? email;

  // body berisi isi komentar.
  final String? body;

  // Constructor menerima semua field sebagai nullable.
  const Comment({
    this.postId,
    this.id,
    this.name,
    this.email,
    this.body,
  });

  // fromJson digunakan untuk mengubah JSON dari API
  // menjadi object Comment.
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      // Operator ?. dan as? membuat proses parsing lebih aman.
      // Jika field tidak ada, hasilnya null.
      postId: json['postId'] as int?,
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      body: json['body'] as String?,
    );
  }
}