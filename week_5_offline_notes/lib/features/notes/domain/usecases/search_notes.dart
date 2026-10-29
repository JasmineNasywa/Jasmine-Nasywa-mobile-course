import '../entities/note.dart';

class SearchNotes {
  List<Note> execute(List<Note> notes, String query) {
    if (query.trim().isEmpty) {
      return notes;
    }
    final cleanQuery = query.toLowerCase().trim();
    return notes.where((note) {
      return note.title.toLowerCase().contains(cleanQuery);
    }).toList();
  }
}