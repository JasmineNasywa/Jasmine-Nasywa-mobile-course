/// Tidak ada URL/secret yang di-hardcode.
/// Jalankan: flutter run --dart-define=API_BASE_URL=https://api.kampus.example
class Config {
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const topicAnnouncement = 'pengumuman-kampus';
}
