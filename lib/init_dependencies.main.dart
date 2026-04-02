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
  _initAccount();
  _initChat();
  _initChatHistory();
  _initFileManagement();
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
    ..registerFactory<ApiChatRemoteDatasource>(
      () => ApiChatRemoteDatasourceImpl(),
    )
    ..registerFactory<FirebaseChatRepository>(
      () => FirebaseChatRepositoryImpl(
        serviceLocator<FirebaseChatRemoteDataSource>(),
        serviceLocator<ApiChatRemoteDatasource>(),
      ),
    )
    ..registerFactory<GetChatData>(
      () => GetChatData(serviceLocator()),
    )
    ..registerFactory<SendMessage>(
      () => SendMessage(serviceLocator()),
    );
}

void _initChatHistory() {
  serviceLocator
    ..registerFactory<FirebaseChatHistoryRemoteDatasource>(
      () => FirebaseChatHistoryRemoteDatasourceImpl(
        serviceLocator<FirebaseAuth>(),
        serviceLocator<FirebaseFirestore>(),
      ),
    )
    ..registerFactory<FirebaseChatHistoryRepository>(
      () => FirebaseChatHistoryRepositoryImpl(
        serviceLocator<FirebaseChatHistoryRemoteDatasource>(),
      ),
    )
    ..registerFactory<GetChatHistory>(
      () => GetChatHistory(serviceLocator()),
    );
}

void _initFileManagement() {
  serviceLocator
    ..registerFactory<FirebaseFileRemoteDatasource>(
      () => FirebaseFileRemoteDatasourceImpl(
        serviceLocator<FirebaseAuth>(),
        serviceLocator<FirebaseStorage>(),
      ),
    )
    ..registerFactory<FirebaseFileRepository>(
      () => FirebaseFileRepositoryImpl(serviceLocator()),
    )
    ..registerFactory<GetUploadedFiles>(
      () => GetUploadedFiles(serviceLocator()),
    )
    ..registerFactory<UploadFile>(
      () => UploadFile(serviceLocator()),
    )
    ..registerFactory<DeleteFile>(
      () => DeleteFile(serviceLocator()),
    );
}
