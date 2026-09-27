import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    OfflineNotesApp(
      prefs: prefs,
    ),
  );
}

class OfflineNotesApp extends StatefulWidget {
  const OfflineNotesApp({
    super.key,
    required this.prefs,
  });

  final SharedPreferences prefs;

  @override
  State<OfflineNotesApp> createState() => _OfflineNotesAppState();
}

class _OfflineNotesAppState extends State<OfflineNotesApp> {
  late bool _darkMode;

  @override
  void initState() {
    super.initState();

    _darkMode = widget.prefs.getBool('dark_mode') ?? false;
  }

  Future<void> _toggleTheme(bool value) async {
    await widget.prefs.setBool('dark_mode', value);

    setState(() {
      _darkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Offline Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: NotesPage(
        darkMode: _darkMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}