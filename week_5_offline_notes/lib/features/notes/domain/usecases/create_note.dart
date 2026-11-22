import '../entities/note.dart';
import '../repositories/note_repository.dart';
import '/../../../core/failures.dart';

class CreateNote {
  final NoteRepository repository;

  CreateNote(this.repository);

  Future<({Note? note, Failure? failure})> call({
    required String title,
    String body = '',
  }) {
    return repository.addNote(title: title, body: body);
  }
}
