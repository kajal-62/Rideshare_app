import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare_app/features/auth/data/auth_repository.dart';
import 'package:rideshare_app/features/auth/providers/auth_providers.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final role = ref.watch(userRoleProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Rideshare - $role'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
            await ref.read(authRepositoryProvider).signOut();
            if (context.mounted) context.go('/login');
          },
          ),
        ],
      ),
      body: const Center(
        child: Text('Map coming next',style: TextStyle(fontSize: 20),),
      ),
    );
  }
}
