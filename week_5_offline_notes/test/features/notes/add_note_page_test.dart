import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:week_5_offline_notes/features/notes/presentation/pages/add_note_page.dart';
import 'package:week_5_offline_notes/features/notes/presentation/providers/notes_providers.dart';

import 'package:week_5_offline_notes/core/failures.dart';

import '../../helpers/fake_note_repository.dart';

void main() {
  late FakeNoteRepositorySuccess fakeRepository;

  setUp(() {
    fakeRepository = FakeNoteRepositorySuccess();
  });

  Future<void> pumpAddNotePage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [noteRepositoryProvider.overrideWithValue(fakeRepository)],
        child: const MaterialApp(home: AddNotePage()),
      ),
    );

    await tester.pumpAndSettle();
  }

  group('AddNotePage Widget Test', () {
    testWidgets('should display Add Note form', (tester) async {
      await pumpAddNotePage(tester);

      expect(find.text('Add Note'), findsOneWidget);
      expect(find.text('Judul catatan'), findsOneWidget);
      expect(find.text('Mulai menulis catatan...'), findsOneWidget);
      expect(find.byTooltip('Save Note'), findsOneWidget);
    });

    testWidgets('should show validation when title is empty', (tester) async {
      await pumpAddNotePage(tester);

      await tester.tap(find.byTooltip('Save Note'));
      await tester.pump();

      expect(find.text('Judul catatan tidak boleh kosong'), findsOneWidget);

      expect(fakeRepository.notes, isEmpty);
    });

    testWidgets('should save note successfully', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [noteRepositoryProvider.overrideWithValue(fakeRepository)],
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddNotePage()),
                    );
                  },
                  child: const Text('Open Add Note'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Add Note'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Judul catatan'),
        'Test Note',
      );

      await tester.enterText(
        find.widgetWithText(TextField, 'Mulai menulis catatan...'),
        'Testing Add Note',
      );

      await tester.tap(find.byTooltip('Save Note'));
      await tester.pumpAndSettle();

      expect(fakeRepository.notes.length, 1);
      expect(fakeRepository.notes.first.title, 'Test Note');
      expect(fakeRepository.notes.first.body, 'Testing Add Note');

      expect(find.text('Open Add Note'), findsOneWidget);
    });
    testWidgets('should show error when repository fails', (tester) async {
      final failingRepository = FakeNoteRepositoryFailure(
        const LocalFailure('Gagal menyimpan catatan'),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            noteRepositoryProvider.overrideWithValue(failingRepository),
          ],
          child: const MaterialApp(home: AddNotePage()),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Judul catatan'),
        'Failed Note',
      );

      await tester.tap(find.byTooltip('Save Note'));

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Gagal menyimpan catatan'), findsOneWidget);
    });
  });
}
