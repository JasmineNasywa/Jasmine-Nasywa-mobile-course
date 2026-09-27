import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/local/note.dart';
import '../widgets/note_tile.dart';
import '../data/repositories/note_repository.dart';
import '../data/sync.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({
    super.key,
    required this.repository,
  });

  final NoteRepository repository;

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> _notes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await widget.repository.fetchNotes();

    if (!mounted) return;

    setState(() {
      _notes = notes;
      _loading = false;
    });
  }

  Future<void> _sync() async {
    await syncNotes(widget.repository);

    if (!mounted) return;

    await _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _sync,
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _notes.isEmpty
              ? const Center(
                  child: Text('Belum ada catatan'),
                )
              : ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];

                    return NoteTile(
                      note: note,
                      onTap: () {
                        context.push('/note/${note.id}');
                      },
                      onDelete: () async {
                        if (note.id == null) return;

                        await widget.repository.deleteNote(note.id!);
                        await _loadNotes();
                      },
                    );
                  },
                ),
    );
  }
}