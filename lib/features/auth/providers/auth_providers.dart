import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare_app/features/auth/data/auth_repository.dart';

final authStateProvider  = StreamProvider<User?>((ref){
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final userRoleProvider = StateProvider<String>((ref) => 'passenger');