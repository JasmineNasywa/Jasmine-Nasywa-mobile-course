import 'package:flutter/material.dart';
import '../data/local/note.dart';
import '../data/repositories/note_repository.dart';

class NoteDetailPage extends StatefulWidget {
  const NoteDetailPage({
    super.key,
    required this.id,
    required this.repository,
  });

  final int id;
  final NoteRepository repository;

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  Note? _note;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final note = await widget.repository.getNote(widget.id);

    if (!mounted) return;

    setState(() {
      _note = note;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_note == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Catatan'),
        ),
        body: const Center(
          child: Text('Catatan tidak ditemukan.'),
        ),
      );
    }

    final note = _note!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(note.body),
            const SizedBox(height: 16),
            if (note.dirty)
              const Chip(
                label: Text('Belum tersinkron'),
              ),
          ],
        ),
      ),
    );
  }
}