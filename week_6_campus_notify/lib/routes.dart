// lib/routes.dart
class AppRoutes {
  static const String login = '/login';
  static const String home = '/';
  static const String pengumuman = '/pengumuman/:id';
  static const String chat = '/chat';
  
  // Helper buat manggil dynamic path kalau butuh ID
  static String pengumumanDetail(String id) => '/pengumuman/$id';
}

