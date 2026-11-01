import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Notify'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            context.push(AppRoutes.chat);
          },
          icon: const Icon(Icons.smart_toy),
          label: const Text('Chat dengan AI'),
        ),
      ),
    );
  }
}