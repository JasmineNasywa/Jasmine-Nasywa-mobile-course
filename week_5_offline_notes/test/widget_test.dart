import 'package:flutter_test/flutter_test.dart';
import 'package:week_5_offline_notes/data/local/note.dart';

void main() {
  test('fromMap aman terhadap field yang hilang', () {
    final note = Note.fromMap({
      'title': 'Belanja',
    });

    expect(note.title, 'Belanja');
    expect(note.body, '');
    expect(note.dirty, isFalse);
  });

  test('flag dirty bertahan pada serialisasi', () {
    final note = Note(
      title: 'a',
      updatedAt: DateTime(2026, 9, 18),
      dirty: true,
    );

    final restored = Note.fromMap(note.toMap());

    expect(restored.dirty, isTrue);
  });
}