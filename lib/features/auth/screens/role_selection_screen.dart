import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare_app/features/auth/providers/auth_providers.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('I am a...',style: TextStyle(
            fontWeight: FontWeight.bold,fontSize: 28
          ),),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _RoleCard(
                label: 'Passenger',
                icon: Icons.person,
                onTap: () {
                  ref.read(userRoleProvider.notifier).state = 'passenger';
                  context.go('/map');
                },
              ),_RoleCard(
                label: 'Driver',
                icon: Icons.directions_car,
                onTap: () {
                  ref.read(userRoleProvider.notifier).state = 'driver';
                  context.go('/map');
                },
              ),

            ],
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _RoleCard({required this.label, required this.icon,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,width: 2
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,size: 48,color: Colors.blue),
            const SizedBox(height: 8,),
            Text(label,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}

