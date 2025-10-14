import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/core/entities/user.dart';
import 'package:verbisense/features/auth/domain/repository/firebase_auth_repository.dart';
import 'package:verbisense/init_dependencies.main.dart';

// In auth_state_provider.dart

final authStateStreamProvider = StreamProvider<User?>((ref) {
  final repository = serviceLocator<FirebaseAuthRepository>();
  return repository.userAuthStateChanges().map((result) {
    return result.fold(
      (failure) => null,
      (user) => user,
    );
  });
});
