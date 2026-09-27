import 'repositories/note_repository.dart';

Future<void> syncNotes(NoteRepository repository) async {
  final dirtyCount = await repository.countDirty();

  if (dirtyCount == 0) {
    return;
  }

  await repository.markAllSynced();
}