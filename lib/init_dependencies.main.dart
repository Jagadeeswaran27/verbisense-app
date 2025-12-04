part of 'init_dependencies.dart';

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
  _initChat();
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

void _initChat() {
  serviceLocator
    ..registerFactory<FirebaseChatRemoteDataSource>(
      () => FirebaseChatRemoteDataSourceImpl(
        serviceLocator<FirebaseFirestore>(),
        serviceLocator<FirebaseAuth>(),
      ),
    )
    ..registerFactory<FirebaseChatRepository>(
      () => FirebaseChatRepositoryImpl(serviceLocator()),
    )
    ..registerFactory<GetChatData>(
      () => GetChatData(serviceLocator()),
    );
}
