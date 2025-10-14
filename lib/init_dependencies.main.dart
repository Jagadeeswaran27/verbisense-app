import 'package:get_it/get_it.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:verbisense/core/config/firebase_push_notification.dart';
import 'package:verbisense/features/auth/data/datasources/firebase_remote_data_source.dart';
import 'package:verbisense/features/auth/data/repositories/firebase_auth_repository_impl.dart';
import 'package:verbisense/features/auth/domain/repository/firebase_auth_repository.dart';
import 'package:verbisense/features/auth/domain/usecases/create_user.dart';
import 'package:verbisense/features/auth/domain/usecases/email_signin.dart';
import 'package:verbisense/features/auth/domain/usecases/google_signin.dart';
import 'package:verbisense/features/auth/domain/usecases/signout.dart';
import 'package:verbisense/features/auth/domain/usecases/update_fcm.dart';
import 'package:verbisense/features/drawer/data/datasources/firebase_drawer_remote_data_source.dart';
import 'package:verbisense/features/drawer/data/repositories/firebase_drawer_repository_impl.dart';
import 'package:verbisense/features/drawer/domain/repository/firebase_drawer_repository.dart';
import 'package:verbisense/features/drawer/domain/usecases/get_chat_history.dart';
import 'package:verbisense/features/drawer/domain/usecases/get_uploaded_files.dart';
import 'package:verbisense/firebase_options.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final firebase = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  serviceLocator.registerLazySingleton(() => firebase);
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => FirebasePushNotification);

  _initAuth();
  _initDrawer();
}

void _initAuth() {
  serviceLocator
    ..registerFactory<FirebaseRemoteDataSource>(
      () => FirebaseRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<FirebaseAuthRepository>(
      () => FirebaseAuthRepositoryImpl(serviceLocator()),
    )
    ..registerFactory<CreateUser>(
      () => CreateUser(serviceLocator()),
    )
    ..registerFactory<EmailSignin>(
      () => EmailSignin(serviceLocator()),
    )
    ..registerFactory<GoogleSignin>(
      () => GoogleSignin(serviceLocator()),
    )
    ..registerFactory<Signout>(
      () => Signout(serviceLocator()),
    )
    ..registerFactory(
      () => UpdateFcm(serviceLocator()),
    );
}

void _initDrawer() {
  serviceLocator
    ..registerFactory<FirebaseDrawerRemoteDataSource>(
      () => FirebaseDrawerRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<FirebaseDrawerRepository>(
      () => FirebaseDrawerRepositoryImpl(serviceLocator()),
    )
    ..registerFactory<GetUploadedFiles>(
      () => GetUploadedFiles(serviceLocator()),
    )
    ..registerFactory<GetChatHistory>(
      () => GetChatHistory(serviceLocator()),
    );
}
