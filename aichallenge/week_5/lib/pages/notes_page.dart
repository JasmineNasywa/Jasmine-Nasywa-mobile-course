import 'package:flutter/material.dart';

import '../data/models/post.dart';
import '../data/local/db.dart';
import '../data/repositories/note_repository.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NotesDatabase _database = NotesDatabase.instance;

  List<Map<String, dynamic>> _notes = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _database.getNotes();

    if (!mounted) return;

    setState(() {
      _notes = notes;
      _loading = false;
    });
  }

  Future<void> _addNote() async {
    await _showNoteDialog();
  }

  Future<void> _editNote(Map<String, dynamic> note) async {
    await _showNoteDialog(
      note: note,
    );
  }

  Future<void> _showNoteDialog({
    Map<String, dynamic>? note,
  }) async {
    final titleController = TextEditingController(
      text: note?['title'] ?? '',
    );

    final bodyController = TextEditingController(
      text: note?['body'] ?? '',
    );

    final isEditing = note != null;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            isEditing ? 'Edit Catatan' : 'Tambah Catatan',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bodyController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Isi catatan',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final body = bodyController.text.trim();

                if (title.isEmpty) {
                  return;
                }

                if (isEditing) {
                  await _database.updateNote(
                    id: note['id'] as int,
                    title: title,
                    body: body,
                  );
                } else {
                  await _database.insertNote(
                    title: title,
                    body: body,
                  );
                }

                if (!context.mounted) return;

                Navigator.pop(context);

                await _loadNotes();
              },
              child: Text(
                isEditing ? 'Simpan' : 'Tambah',
              ),
            ),
          ],
        );
      },
    );

    titleController.dispose();
    bodyController.dispose();
  }

  Future<void> _deleteNote(int id) async {
    await _database.deleteNote(id);

    await _loadNotes();
  }

  Future<void> _generate1000Notes() async {
    await _database.generateDummyNotes();

    await _loadNotes();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '1000 catatan dummy berhasil ditambahkan.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Notes'),
        actions: [
          IconButton(
            tooltip: 'Tambah catatan',
            onPressed: _addNote,
            icon: const Icon(Icons.add),
          ),

          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'generate') {
                _generate1000Notes();
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: 'generate',
                  child: Text('Generate 1000 catatan'),
                ),
              ];
            },
          ),

          Switch(
            value: widget.darkMode,
            onChanged: widget.onThemeChanged,
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _notes.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada catatan.',
                  ),
                )
              : ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];

                    return ListTile(
                      title: Text(
                        note['title'] as String,
                      ),
                      subtitle: Text(
                        note['body'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: () {
                              _editNote(note);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            tooltip: 'Hapus',
                            onPressed: () {
                              _deleteNote(note['id'] as int);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}