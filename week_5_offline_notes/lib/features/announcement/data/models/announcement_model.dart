// lib/features/announcement/data/models/announcement_model.dart
import '../../domain/entities/announcement.dart';

class AnnouncementModel extends Announcement {
  const AnnouncementModel({
    super.id,
    required super.title,
    super.content,
    required super.date,
  });

  // Konversi dari Map (database/json) ke Model
  factory AnnouncementModel.fromMap(Map<String, dynamic> map) {
    return AnnouncementModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String? ?? '',
      // Tanggal biasanya disimpan sebagai String (ISO8601) atau int (milliseconds), kita parse ke DateTime:
      date: DateTime.parse(map['date'] as String),
    );
  }

  // Konversi dari Model ke Map (untuk disimpen ke database/json)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(), // Simpan DateTime jadi format String
    };
  }

  // Ubah Model ini kembali ke bentuk Entity murni (sesuai aturan Clean Architecture)
  Announcement toEntity() {
    return Announcement(
      id: id,
      title: title,
      content: content,
      date: date,
    );
  }
}