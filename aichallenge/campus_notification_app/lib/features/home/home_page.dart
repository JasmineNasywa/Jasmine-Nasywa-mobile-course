import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subscriptionProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Notification')),
      body: ListView(
        children: [
          sub.when(
            data: (v) => SwitchListTile(
              title: const Text('Pengumuman Kampus'),
              subtitle: const Text('Topic: pengumuman-kampus'),
              value: v,
              onChanged: (x) => ref.read(subscriptionProvider.notifier).set(x),
            ),
            loading: () => const ListTile(title: LinearProgressIndicator()),
            error: (e, _) => ListTile(title: Text('Gagal: $e')),
          ),
        ],
      ),
    );
  }
}
