import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  NotesDatabase._();

  static final NotesDatabase instance = NotesDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _openDatabase();

    return _database!;
  }

  Future<Database> _openDatabase() async {
    final databasesPath = await getDatabasesPath();

    final path = p.join(
      databasesPath,
      'offline_notes_challenge.db',
    );

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            body TEXT NOT NULL DEFAULT '',
            updated_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;

    return db.query(
      'notes',
      orderBy: 'updated_at DESC',
    );
  }

  Future<int> insertNote({
    required String title,
    required String body,
  }) async {
    final db = await database;

    return db.insert(
      'notes',
      {
        'title': title,
        'body': body,
        'updated_at': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> updateNote({
    required int id,
    required String title,
    required String body,
  }) async {
    final db = await database;

    await db.update(
      'notes',
      {
        'title': title,
        'body': body,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await database;

    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> generateDummyNotes() async {
    final db = await database;

    final batch = db.batch();

    for (int i = 1; i <= 1000; i++) {
      batch.insert(
        'notes',
        {
          'title': 'Catatan $i',
          'body': 'Isi catatan dummy ke-$i.',
          'updated_at':
              DateTime.now().add(Duration(seconds: i)).toIso8601String(),
        },
      );
    }

    await batch.commit(noResult: true);
  }
}