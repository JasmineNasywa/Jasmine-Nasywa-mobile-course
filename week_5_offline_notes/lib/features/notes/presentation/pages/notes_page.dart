
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/notes_providers.dart';
import '../widgets/error_view.dart';
import '../widgets/add_note_button.dart';
import 'add_note_page.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: state.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => ErrorView(
          message: '$e',
          onRetry: () => ref.invalidate(notesProvider),
        ),
        data: (notes) {
          final filteredNotes =
              ref.watch(filteredNotesProvider(notes));

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    ref
                        .read(searchQueryProvider.notifier)
                        .setQuery(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari judul notes...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: filteredNotes.isEmpty
                    ? const Center(
                        child: Text('Catatan tidak ditemukan'),
                      )
                    : ListView.builder(
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) {
                          final note = filteredNotes[index];

                          return ListTile(
                            title: Text(note.title),
                            subtitle: Text(note.body),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: AddNoteButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddNotePage(),
            ),
          );
        },
      ),
    );
  }
}
