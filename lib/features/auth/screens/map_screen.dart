import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare_app/features/auth/data/auth_repository.dart';
import 'package:rideshare_app/features/auth/providers/auth_providers.dart';
import 'package:rideshare_app/features/auth/providers/location_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  bool _followUser = true;

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(liveLocationProvider);
    final role = ref.watch(userRoleProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: locationAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF2563EB)),
              SizedBox(height: 16.0),
              Text('Getting your location..........'),
            ],
          ),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 64.0, color: Colors.red),
              const SizedBox(height: 16.0),
              Text('Location error : $e'),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => ref.refresh(liveLocationProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (latLng) {
          if (_followUser) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _mapController.move(latLng, 16);
            });
          }
          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: latLng,
                  initialZoom: 16,
                  onPositionChanged: (_, hasGesture) {
                    if (hasGesture && _followUser) {
                      setState(() => _followUser = false);
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: isDark
                        ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png'
                        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.rideshare_app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: latLng,
                        width: 60.0,
                        height: 60.0,
                        child: _buildUserMarker(role),
                      ),
                    ],
                  ),
                ],
              ),

              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E2930)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.15),
                                blurRadius: 10.0,
                                offset: const Offset(0.0, 3.0),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                role == 'driver'
                                    ? Icons.directions_car
                                    : Icons.person,
                                color: const Color(0xFF2563EB),
                                size: 18.0,
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                role == 'driver' ? 'Driver' : 'Passenger',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),

                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10.0,
                                offset: const Offset(0.0, 3.0),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () async {
                              await ref.read(authRepositoryProvider).signOut();
                              if (context.mounted) context.go('/login');
                            },
                            icon: Icon(Icons.logout, color: Color(0xFF2563EB)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 32.0,
                left: 16.0,
                right: 16.0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 16.0,
                        offset: const Offset(0.0, 0.4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 44.0,
                        width: 44.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2563EB).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Location',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              '${latLng.latitude.toStringAsFixed(5)},${latLng.longitude.toStringAsFixed(5)}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: isDark ? Colors.white54 : Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (!_followUser)
                Positioned(
                  bottom: 120.0,
                  right: 16.0,
                  child: FloatingActionButton.small(
                    onPressed: () {
                      setState(() => _followUser = true);
                      _mapController.move(latLng, 16);
                    },
                    child: const Icon(Icons.my_location, color: Colors.white),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserMarker(String role) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.4),
            blurRadius: 8.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Icon(
        role == 'driver' ? Icons.directions_car : Icons.person,
        color: Colors.white,
        size: 26.0,
      ),
    );
  }
}
