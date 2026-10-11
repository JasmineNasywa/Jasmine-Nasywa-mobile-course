// lib/routes.dart
class AppRoutes {
  // Rute Utama & Notes
  static const String home = '/'; // Halaman utama (Notes)
  static const String noteDetail = '/notes/:id';

  // Rute Announcements
  static const String announcements = '/announcements';
  static const String announcementDetail = '/announcements/:id';

  // Helper function buat navigasi yang butuh ID
  static String noteDetailPath(String id) => '/notes/$id';
  static String announcementDetailPath(String id) => '/announcements/$id';
}