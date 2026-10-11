import '../../../../core/failures.dart';
import '../entities/announcement.dart';

abstract class AnnouncementRepository {
  // Pakai 'announcements' (pakai s)
  Future<({List<Announcement> announcements, Failure? failure})> fetchAnnouncements();

  Future<({Announcement? announcement, Failure? failure})> addAnnouncement({
    required String title,
    required String content,
    required DateTime date,
  });
}