import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/announcement_providers.dart';

class AnnouncementPage extends ConsumerWidget {
  const AnnouncementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsState = ref.watch(announcementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengumuman'),
      ),
      body: announcementsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Gagal memuat pengumuman: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (announcements) => announcements.isEmpty
            ? const Center(child: Text('Belum ada pengumuman.'))
            : ListView.builder(
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
                  return ListTile(
                    title: Text(announcement.title),
                    subtitle: Text(announcement.content),
                    trailing: Text(announcement.date.toLocal().toString().split(' ')[0]),
                  );
                },
              ),
      ),
    );
  }
}