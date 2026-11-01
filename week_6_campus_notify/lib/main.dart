import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'pages/chat_page.dart';
import 'routes.dart'; // Import routes.dart yang baru dibuat

// ==========================================
// 1. BACKGROUND HANDLER & PURE FUNCTION
// ==========================================
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

// Fungsi murni buat parsing RemoteMessage -> route (bisa di-unit-test tanpa Firebase)
String routeFromMessage(Map<String, dynamic> data) {
  return data['route'] ?? AppRoutes.home;
}

// ==========================================
// 2. FCM SERVICE KELAS UTAMA
// ==========================================
class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FlutterLocalNotificationsPlugin _localNotification = FlutterLocalNotificationsPlugin();

  Future<void> initNotification(void Function(String route) onRouteSelected) async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotification.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;
        if (payload != null && payload.isNotEmpty) {
          onRouteSelected(payload);
        }
      },
    );

    const androidChannel = AndroidNotificationChannel(
      'pengumuman_channel',
      'Pengumuman Kampus',
      description: 'Channel untuk notifikasi penting kampus',
      importance: Importance.high,
    );

    await _localNotification
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void listenForeground(void Function(String route) onRouteSelected) {
    FirebaseMessaging.onMessage.listen((message) async {
      final route = routeFromMessage(message.data);
      
      const androidDetails = AndroidNotificationDetails(
        'pengumuman_channel', 
        'Pengumuman Kampus',
        importance: Importance.high, 
        priority: Priority.high,
      );
      
      await _localNotification.show(
        id: message.hashCode,
        title: message.notification?.title ?? 'Pengumuman',
        body: message.notification?.body ?? '',
        notificationDetails:const NotificationDetails(android: androidDetails),
        payload: route,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final route = routeFromMessage(message.data);
      onRouteSelected(route);
    });
  }

  Future<void> handleTerminated(void Function(String route) onRouteSelected) async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      final route = routeFromMessage(initialMessage.data);
      onRouteSelected(route);
    }
  }
}

// ==========================================
// 3. GO_ROUTER CONFIGURATION
// ==========================================
final router = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.pengumuman,
      builder: (_, s) => AnnouncementPage(
        id: s.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.chat,
      builder: (_, __) => const ChatPage(),
    ),
  ],
);

// ==========================================
// 4. MAIN FUNCTION
// ==========================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final fcmService = FcmService();
  await fcmService.initNotification((route) {
    router.go(route);
  });

  runApp(const MyApp());
}

// ==========================================
// 5. APP WIDGET
// ==========================================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FcmService _fcmService = FcmService();

  @override
  void initState() {
    super.initState();
    
    _fcmService.listenForeground((route) {
      router.go(route);
    });
    
    _fcmService.handleTerminated((route) {
      router.go(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// ==========================================
// 6. DUMMY PAGES
// ==========================================
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go(AppRoutes.home);
          },
          child: const Text('Masuk ke Campus Notify'),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Notify'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school_rounded,
                size: 64,
                color: Color(0xFF315CDB),
              ),
              const SizedBox(height: 16),
              const Text(
                'Selamat Datang!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Campus Notify siap membantu aktivitas kampusmu.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(AppRoutes.chat);
                  },
                  icon: const Icon(Icons.smart_toy_rounded),
                  label: const Text('Chat dengan AI'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF315CDB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnnouncementPage extends StatelessWidget {
  final String id;
  const AnnouncementPage({super.key, required this.id});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Detail Pengumuman ID: $id')));
}