import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notes_providers.dart';

class NoteSearchBar extends ConsumerWidget {
  const NoteSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          // Panggil method setQuery, jangan langsung ubah .state dari luar!
          ref.read(searchQueryProvider.notifier).setQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Cari judul notes...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}

// Widget Empty State bisa ditaruh di sini atau di file terpisah
class NoteEmptyView extends ConsumerWidget {
  const NoteEmptyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            query.isEmpty 
                ? 'Belum ada catatan' 
                : 'Catatan dengan kata "$query" tidak ditemukan',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}