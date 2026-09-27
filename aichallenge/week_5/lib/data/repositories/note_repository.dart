import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../api_client.dart';
import '../models/post.dart';
import '../local/db.dart';
import '../local/note.dart';
import 'post_repository.dart';

class NoteRepository {
  NoteRepository({
    Future<Database> Function()? openDb,
    PostRepository? postRepository,
  })  : _openDb = openDb ?? openNotesDb,
        _postRepository =
            postRepository ?? PostRepository(createDio());

  final Future<Database> Function() _openDb;
  final PostRepository _postRepository;


  Future<List<Note>> fetchNotes() async {
    final db = await _openDb();
    final rows = await db.query('notes', orderBy: 'updated_at DESC');
    return rows.map(Note.fromMap).toList();
  }

  Future<Note> addNote({required String title, String body = ''}) async {
    final db = await _openDb();
    final note = Note(
      title: title,
      body: body,
      updatedAt: DateTime.now(),
      dirty: true,
    );
    final id = await db.insert('notes', note.toMap());
    return Note(
      id: id,
      title: note.title,
      body: note.body,
      updatedAt: note.updatedAt,
      dirty: true,
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await _openDb();
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countDirty() async {
    final db = await _openDb();
    final rows = await db.rawQuery(
        'SELECT COUNT(*) AS c FROM notes WHERE dirty = 1');
    return ((rows.first['c'] as num?)?.toInt() ?? 0);
  }

  Future<void> markAllSynced() async {
    final db = await _openDb();
    await db.update('notes', {'dirty': 0}, where: 'dirty = 1');
  }

  Future<void> refreshPostsInBackground() async {
  try {
    final posts = await _postRepository.fetchPosts();

    final db = await _openDb();

    final payload = jsonEncode(
      posts.map((post) => post.toJson()).toList(),
    );

    await db.insert(
      'cached_posts',
      {
        'id': 1,
        'payload': payload,
        'cached_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } catch (_) {
    // Kalau internet/API gagal, cache lama tetap bisa dipakai.
  }
}

Future<List<Post>> loadPostsCacheFirst() async {
  final db = await _openDb();

  final rows = await db.query(
    'cached_posts',
    orderBy: 'cached_at DESC',
    limit: 1,
  );

  List<Post> cached = [];

  if (rows.isNotEmpty) {
    final payload = rows.first['payload'] as String;

    final decoded = jsonDecode(payload);

    if (decoded is List) {
      cached = decoded
          .whereType<Map<String, dynamic>>()
          .map(Post.fromJson)
          .toList();
    }
  }

  refreshPostsInBackground();

  return cached;
}
Future<void> syncNotes() async {

  await markAllSynced();
}

}