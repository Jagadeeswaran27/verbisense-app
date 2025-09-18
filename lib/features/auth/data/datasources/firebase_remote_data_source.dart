import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/error/exceptions.dart';
import 'package:verbisense/features/auth/data/models/user_model.dart';

abstract class FirebaseRemoteDataSource {
  Future<UserModel> createUserWithEmailAndPassword(
    String name,
    String email,
    String password,
  );
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Stream<User?> userAuthStateChanges();
}

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions.instance;
  FirebaseRemoteDataSourceImpl(this.firebaseAuth);
  @override
  Future<UserModel> createUserWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      final HttpsCallable callable = _firebaseFunctions.httpsCallable(
        'createUser',
      );
      final result = await callable.call({
        'email': email,
        'password': password,
        'name': name,
      });

      final rawUserData = result.data['user'];
      final userData = Map<String, dynamic>.from(rawUserData as Map);
      final user = UserModel.fromJson(userData);

      return user;
    } on FirebaseFunctionsException catch (e) {
      switch (e.code) {
        case 'already-exists':
          throw const ServerException('Email already in use');
        case 'invalid-argument':
          throw const ServerException('Invalid input provided');
        case 'internal':
          throw ServerException(e.message ?? 'Internal server error');
        default:
          throw ServerException(e.message ?? 'Unknown server error');
      }
    } catch (e) {
      AppLogger.e(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw const ServerException('User data is null');
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        throw const ServerException('User data not found');
      }
      return UserModel.fromJson(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e.code);
      switch (e.code) {
        case 'invalid-credential':
          throw const ServerException('Invalid credential');
        case 'user-disabled':
          throw const ServerException('User disabled');
        case 'user-not-found':
          throw const ServerException('User not found');
        case 'wrong-password':
          throw const ServerException('Wrong password');
        default:
          throw ServerException(e.message ?? 'Authentication error');
      }
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();
      await _googleSignIn.signOut();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email'],
      );
      final authClient = _googleSignIn.authorizationClient;
      final autherization = await authClient.authorizationForScopes(['email']);
      if (autherization == null) {
        throw const ServerException('You have cancelled the signin');
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: autherization.accessToken,
        idToken: googleUser.authentication.idToken,
      );
      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      if (user == null) {
        throw const ServerException('User data is null');
      }
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data()!);
      } else {
        final userData = {
          "uid": user.uid,
          "email": user.email,
          "name": user.displayName,
        };
        await _firestore.collection("users").doc(user.uid).set(userData);
        return UserModel.fromJson(userData);
      }
    } on GoogleSignInException catch (e) {
      AppLogger.e(e.code.toString());
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
          throw const ServerException('You cancelled the signin');
        case GoogleSignInExceptionCode.clientConfigurationError:
          throw const ServerException('client error!');
        case GoogleSignInExceptionCode.interrupted:
          throw const ServerException('Signin Interrupted');
        case GoogleSignInExceptionCode.uiUnavailable:
          throw const ServerException('UI Unavailable');
        default:
          throw ServerException(e.code.name);
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e.code);
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw const ServerException(
            'Account exists with different credential',
          );
        case 'invalid-credential':
          throw const ServerException('Invalid credential');
        case 'operation-not-allowed':
          throw const ServerException('Operation not allowed');
        case 'user-disabled':
          throw const ServerException('User disabled');
        case 'user-not-found':
          throw const ServerException('User not found');
        case 'wrong-password':
          throw const ServerException('Wrong password');
        default:
          throw ServerException(e.message ?? 'Authentication error');
      }
    } catch (e) {
      AppLogger.e(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<User?> userAuthStateChanges() async* {
    yield* firebaseAuth.authStateChanges();
  }

  @override
  Future<void> signOut() {
    try {
      return firebaseAuth.signOut();
    } catch (e) {
      AppLogger.e(e.toString());
      throw ServerException(e.toString());
    }
  }
}
