
import 'package:flutter_test/flutter_test.dart';
import 'package:week_5_offline_notes/features/notes/domain/usecases/create_note.dart';
import 'package:week_5_offline_notes/core/failures.dart';

import '../../../test/helpers/fake_note_repository.dart';

void main() {
  group('CreateNote', () {
    late FakeNoteRepositorySuccess fakeRepository;
    late CreateNote createNote;

    setUp(() {
      fakeRepository = FakeNoteRepositorySuccess();
      createNote = CreateNote(fakeRepository);
    });

    group('when input is valid', () {
      test('should create a note successfully', () async {
        final result = await createNote(
          title: 'Test Note',
          body: 'Test Body',
        );

        expect(result.failure, isNull);
        expect(result.note, isNotNull);
        expect(result.note!.title, 'Test Note');
        expect(result.note!.body, 'Test Body');
        expect(result.note!.dirty, true);
      });
    });

    group('when body is empty', () {
      test('should create note with empty body', () async {
        final result = await createNote(
          title: 'Empty Body',
        );

        expect(result.failure, isNull);
        expect(result.note!.body, '');
      });
    });

    group('when repository fails', () {
      test('should return repository failure', () async {
        final failure = LocalFailure('Database error');
        final failingRepository =
            FakeNoteRepositoryFailure(failure);

        final useCase = CreateNote(failingRepository);

        final result = await useCase(
          title: 'Failed Note',
        );

        expect(result.note, isNull);
        expect(result.failure, same(failure));
      });
    });
  });
}
