import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import 'router.dart';

class CampusApp extends ConsumerStatefulWidget {
  const CampusApp({super.key});
  @override
  ConsumerState<CampusApp> createState() => _CampusAppState();
}

class _CampusAppState extends ConsumerState<CampusApp> {
  @override
  void initState() {
    super.initState();
    // Setelah frame pertama, router siap menerima navigasi
    // dari getInitialMessage (kasus terminated).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pushServiceProvider).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Campus Notification',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
