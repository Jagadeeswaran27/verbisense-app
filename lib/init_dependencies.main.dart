import 'package:get_it/get_it.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:verbisense/features/auth/data/datasources/firebase_remote_data_source.dart';
import 'package:verbisense/features/auth/data/repositories/firebase_auth_repository_impl.dart';
import 'package:verbisense/features/auth/domain/repository/firebase_auth_repository.dart';
import 'package:verbisense/features/auth/domain/usecases/create_user.dart';
import 'package:verbisense/firebase_options.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final firebase = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  serviceLocator.registerLazySingleton(() => firebase);
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);

  _initAuth();
}

void _initAuth() {
  // DataSource
  serviceLocator
    ..registerFactory<FirebaseRemoteDataSource>(
      () => FirebaseRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<FirebaseAuthRepository>(
      () => FirebaseAuthRepositoryImpl(serviceLocator()),
    )
    ..registerFactory<CreateUser>(
      () => CreateUser(serviceLocator()),
    );
}
