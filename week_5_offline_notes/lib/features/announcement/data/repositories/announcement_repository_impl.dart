import 'package:sqflite/sqflite.dart';
import '../../../../core/failures.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../models/announcement_model.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  const AnnouncementRepositoryImpl(this._openDb);

  final Future<Database> Function() _openDb;

  @override
  Future<({List<Announcement> announcements, Failure? failure})> fetchAnnouncements() async {
    try {
      final db = await _openDb();
      final result = await db.query('announcements');
      final announcements = result
          .map((map) => AnnouncementModel.fromMap(map).toEntity())
          .toList();
      return (announcements: announcements, failure: null);
    } catch (e) {
      // Perhatikan <Announcement>[] biar gak kebaca List<dynamic>!
      return (announcements: <Announcement>[], failure: LocalFailure(e.toString()));
    }
  }

  @override
  Future<({Announcement? announcement, Failure? failure})> addAnnouncement({
    required String title,
    required String content,
    required DateTime date,
  }) async {
    try {
      final db = await _openDb();
      final model = AnnouncementModel(
        title: title,
        content: content,
        date: date,
      );
      
      final id = await db.insert('announcements', model.toMap());
      final createdAnnouncement = Announcement(
        id: id,
        title: title,
        content: content,
        date: date,
      );

      return (announcement: createdAnnouncement, failure: null);
    } catch (e) {
      return (announcement: null, failure: LocalFailure(e.toString()));
    }
  }
}