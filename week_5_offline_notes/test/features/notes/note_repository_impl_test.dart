import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:week_5_offline_notes/features/notes/data/repositories/note_repository_impl.dart';

void main() {
  late Database db;
  late NoteRepositoryImpl repository;

  setUp(() async {
    sqfliteFfiInit();

    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        body TEXT NOT NULL DEFAULT '',
        updated_at TEXT NOT NULL,
        dirty INTEGER NOT NULL DEFAULT 0
      )
    ''');

    repository = NoteRepositoryImpl(() async => db);
  });

  tearDown(() async {
    await db.close();
  });

  group('NoteRepositoryImpl - fetchNotes', () {
    test('should return empty list when database is empty', () async {
      final result = await repository.fetchNotes();

      expect(result.notes, isEmpty);
      expect(result.failure, isNull);
    });

    test('should return saved notes from database', () async {
      await db.insert('notes', {
        'title': 'Test Note',
        'body': 'Testing repository',
        'updated_at': DateTime.now().toIso8601String(),
        'dirty': 1,
      });

      final result = await repository.fetchNotes();

      expect(result.failure, isNull);
      expect(result.notes.length, 1);
      expect(result.notes.first.title, 'Test Note');
      expect(result.notes.first.body, 'Testing repository');
      expect(result.notes.first.dirty, true);
    });

    test('should return failure when database access fails', () async {
      final failingRepository = NoteRepositoryImpl(() async {
        throw Exception('Database error');
      });

      final result = await failingRepository.fetchNotes();

      expect(result.notes, isEmpty);
      expect(result.failure, isNotNull);
    });
  });

  group('NoteRepositoryImpl - addNote', () {
    test('should save a note successfully', () async {
      final result = await repository.addNote(
        title: 'My First Note',
        body: 'Hello Flutter',
      );

      expect(result.failure, isNull);
      expect(result.note, isNotNull);
      expect(result.note!.id, isNotNull);
      expect(result.note!.title, 'My First Note');
      expect(result.note!.body, 'Hello Flutter');
      expect(result.note!.dirty, true);
    });

    test('should save note with empty body', () async {
      final result = await repository.addNote(title: 'Empty Body');

      expect(result.failure, isNull);
      expect(result.note!.body, '');
    });

    test('should return failure when database insert fails', () async {
      final failingRepository = NoteRepositoryImpl(() async {
        throw Exception('Database error');
      });

      final result = await failingRepository.addNote(title: 'Failed Note');

      expect(result.note, isNull);
      expect(result.failure, isNotNull);
    });
  });
}
