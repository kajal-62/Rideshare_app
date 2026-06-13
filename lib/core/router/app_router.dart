import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare_app/features/auth/providers/auth_providers.dart';
import 'package:rideshare_app/features/auth/screens/login_screen.dart';
import 'package:rideshare_app/features/auth/screens/map_screen.dart';
import 'package:rideshare_app/features/auth/screens/register_screen.dart';
import 'package:rideshare_app/features/auth/screens/role_selection_screen.dart';
import 'package:rideshare_app/features/splash/splash_screen.dart';


final routerProvider = Provider((ref) {
  final authstate = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
      redirect: (context , state){
        final isLoggedIn = authstate.valueOrNull != null ;
        final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/';

        if (!isLoggedIn && !isAuthRoute) return '/login';
        if (isLoggedIn && state.matchedLocation == '/login') return '/map';
        if (isLoggedIn && state.matchedLocation == '/register') return '/map';
        return null ;
      },
      routes: [
        GoRoute(path: '/',builder: (_,__) => const SplashScreen()),
       GoRoute(path: '/login',builder: (_,__) => const LoginScreen()),
       GoRoute(path: '/register', builder: (_,__) => const RegisterScreen()),
       GoRoute(path: '/role',builder: (_,__) => const RoleSelectionScreen()),
        GoRoute(path: '/map',builder: (_,__) => const MapScreen()),
  ]);
});