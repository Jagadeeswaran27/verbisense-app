import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:verbisense/core/config/firebase_push_notification.dart';
import 'package:verbisense/core/data/datasources/firebase_auth_core_remote_datasource.dart';
import 'package:verbisense/core/data/repositories/firebase_auth_core_repository_impl.dart';
import 'package:verbisense/core/domain/repository/firebase_auth_core_repository.dart';
import 'package:verbisense/core/domain/usecases/get_current_user.dart';
import 'package:verbisense/core/domain/usecases/signout.dart';
import 'package:verbisense/core/domain/usecases/update_fcm.dart';
import 'package:verbisense/features/account/data/datasources/firebase_account_remote_datasource.dart';
import 'package:verbisense/features/account/data/repositories/firebase_account_repository_impl.dart';
import 'package:verbisense/features/account/domain/repository/firebase_account_repository.dart';
import 'package:verbisense/features/account/domain/usecases/change_password.dart';
import 'package:verbisense/features/account/domain/usecases/get_user_provider_info.dart';
import 'package:verbisense/features/account/domain/usecases/update_user_name.dart';
import 'package:verbisense/features/auth/data/datasources/firebase_auth_remote_data_source.dart';
import 'package:verbisense/features/auth/data/repositories/firebase_auth_repository_impl.dart';
import 'package:verbisense/features/auth/domain/repository/firebase_auth_repository.dart';
import 'package:verbisense/features/auth/domain/usecases/create_user.dart';
import 'package:verbisense/features/auth/domain/usecases/email_signin.dart';
import 'package:verbisense/features/auth/domain/usecases/google_signin.dart';
import 'package:verbisense/features/drawer/data/datasources/firebase_drawer_remote_data_source.dart';
import 'package:verbisense/features/drawer/data/repositories/firebase_drawer_repository_impl.dart';
import 'package:verbisense/features/drawer/domain/repository/firebase_drawer_repository.dart';
import 'package:verbisense/features/drawer/domain/usecases/delete_file.dart';
import 'package:verbisense/features/drawer/domain/usecases/get_chat_history.dart';
import 'package:verbisense/features/drawer/domain/usecases/get_uploaded_files.dart';
import 'package:verbisense/features/drawer/domain/usecases/upload_file.dart';
import 'package:verbisense/firebase_options.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final firebase = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  serviceLocator.registerLazySingleton(() => firebase);
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);
  serviceLocator.registerLazySingleton(() => FirebaseStorage.instance);
  serviceLocator.registerLazySingleton(() => FirebaseFunctions.instance);
  serviceLocator.registerLazySingleton(() => GoogleSignIn.instance);
  serviceLocator.registerLazySingleton(() => FirebasePushNotification());

  _initCore();
  _initAuth();
  _initDrawer();
  _initAccount();
}

void _initCore() {
  serviceLocator
    ..registerFactory<FirebaseAuthCoreRemoteDatasource>(
      () => FirebaseAuthCoreRemoteDatasourceImpl(
        firebaseAuth: serviceLocator<FirebaseAuth>(),
        firestore: serviceLocator<FirebaseFirestore>(),
      ),
    )
    ..registerFactory<FirebaseAuthCoreRepository>(
      () => FirebaseAuthCoreRepositoryImpl(serviceLocator()),
    )
    ..registerFactory<GetCurrentUser>(
      () => GetCurrentUser(serviceLocator()),
    )
    ..registerFactory<Signout>(
      () => Signout(serviceLocator()),
    )
    ..registerFactory<UpdateFcm>(
      () => UpdateFcm(serviceLocator()),
    );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<FirebaseAuthRemoteDataSource>(
      () => FirebaseAuthRemoteDataSourceImpl(
        serviceLocator<FirebaseAuth>(),
        serviceLocator<FirebaseFirestore>(),
        serviceLocator<GoogleSignIn>(),
        serviceLocator<FirebaseFunctions>(),
      ),
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
    );
}

void _initDrawer() {
  serviceLocator
    ..registerFactory<FirebaseDrawerRemoteDataSource>(
      () => FirebaseDrawerRemoteDataSourceImpl(
        serviceLocator<FirebaseAuth>(),
        serviceLocator<FirebaseFirestore>(),
        serviceLocator<FirebaseStorage>(),
      ),
    )
    ..registerFactory<FirebaseDrawerRepository>(
      () => FirebaseDrawerRepositoryImpl(serviceLocator()),
    )
    ..registerFactory<GetUploadedFiles>(
      () => GetUploadedFiles(serviceLocator()),
    )
    ..registerFactory<GetChatHistory>(
      () => GetChatHistory(serviceLocator()),
    )
    ..registerFactory<UploadFile>(
      () => UploadFile(serviceLocator()),
    )
    ..registerFactory<DeleteFile>(
      () => DeleteFile(serviceLocator()),
    );
}

void _initAccount() {
  serviceLocator
    ..registerFactory<FirebaseAccountRemoteDatasource>(
      () => FirebaseAccountRemoteDatasourceImpl(
        serviceLocator<FirebaseAuth>(),
        serviceLocator<FirebaseFirestore>(),
      ),
    )
    ..registerFactory<FirebaseAccountRepository>(
      () => FirebaseAccountRepositoryImpl(serviceLocator()),
    )
    ..registerFactory<GetUserProviderInfo>(
      () => GetUserProviderInfo(serviceLocator()),
    )
    ..registerFactory<UpdateUserName>(
      () => UpdateUserName(serviceLocator()),
    )
    ..registerFactory<ChangePassword>(
      () => ChangePassword(serviceLocator()),
    );
}
