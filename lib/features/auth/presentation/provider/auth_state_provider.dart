import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/core/common/entities/user.dart';
import 'package:verbisense/features/auth/domain/repository/firebase_auth_repository.dart';
import 'package:verbisense/init_dependencies.main.dart';

final authStateStreamProvider = StreamProvider<User?>((ref) async* {
  final repository = serviceLocator<FirebaseAuthRepository>();
  await for (final result in repository.userAuthStateChanges()) {
    yield result.fold((failure) => null, (user) => user);
  }
});
