import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/repositories/note_repository.dart';
import 'pages/notes_page.dart';

import 'pages/note_detail_page.dart';

final repository = NoteRepository();

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return NotesPage(
          repository: repository,
        );
      },
    ),
    GoRoute(
      path: '/note/:id',
      builder: (context, state) {
        final id = int.parse(
          state.pathParameters['id']!,
        );

        return NoteDetailPage(
          id: id,
          repository: repository,
        );
      },
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Offline Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}