
import 'package:week_5_offline_notes/features/notes/domain/entities/note.dart';
import 'package:week_5_offline_notes/features/notes/domain/repositories/note_repository.dart';
import 'package:week_5_offline_notes/core/failures.dart';

class FakeNoteRepositorySuccess implements NoteRepository {
  final List<Note> notes = [];

  int _nextId = 1;

  @override
  Future<({List<Note> notes, Failure? failure})> fetchNotes() async {
  return (
    notes: List<Note>.unmodifiable(notes),
    failure: null,
  );
}

  @override
  Future<({Note? note, Failure? failure})> addNote({
    required String title,
    String body = '',
  }) async {
    final note = Note(
      id: _nextId++,
      title: title,
      body: body,
      updatedAt: DateTime.now(),
      dirty: true,
    );

    notes.add(note);

    return (note: note, failure: null);
  }
}

class FakeNoteRepositoryFailure implements NoteRepository {
  final Failure failure;

  FakeNoteRepositoryFailure(this.failure);

  @override
  Future<({List<Note> notes, Failure? failure})> fetchNotes() async {
    return (notes: const <Note>[], failure: failure);
  }

  @override
  Future<({Note? note, Failure? failure})> addNote({
    required String title,
    String body = '',
  }) async {
    return (note: null, failure: failure);
  }
}
