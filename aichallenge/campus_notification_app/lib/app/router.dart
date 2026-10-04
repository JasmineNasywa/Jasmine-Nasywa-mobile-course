import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/announcement/announcement_page.dart';
import '../features/home/home_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const HomePage()),
      GoRoute(
        path: '/announcement/:id',
        builder: (_, s) => AnnouncementPage(id: s.pathParameters['id']!),
      ),
    ],
  );
});
