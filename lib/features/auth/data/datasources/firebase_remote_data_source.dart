import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/error/exceptions.dart';
import 'package:verbisense/core/error/firebase_error_code.dart';
import 'package:verbisense/core/error/google_signin_error_code.dart';
import 'package:verbisense/core/resources/firebase_error_strings.dart';
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
  Future<bool> updateFcmToken(String token);
}

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions.instance;

  FirebaseRemoteDataSourceImpl(this.firebaseAuth);

  static String getFirebaseError(FirebaseException e) {
    final errorCode = FirebaseErroCodeX.fromCode(e.code);
    if (errorCode != null) {
      return errorCode.message;
    } else {
      return e.message ?? FirebaseErrorStrings.unknownFirebaseError;
    }
  }

  static String getGoogleSignInError(GoogleSignInException e) {
    final errorCode = GoogleSignInErrorCodeX.fromCode(e.code.name);
    if (errorCode != null) {
      return errorCode.message;
    } else {
      return 'An unexpected error occurred during Google Sign-In: ${e.code.name}';
    }
  }

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
      throw ServerException(getFirebaseError(e));
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
        throw const ServerException(FirebaseErrorStrings.userDataIsNull);
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        throw const ServerException(FirebaseErrorStrings.userDataNotFound);
      }
      await user.getIdToken(true);
      return UserModel.fromJson(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e.code);
      throw ServerException(getFirebaseError(e));
    } catch (e) {
      throw ServerException(e.toString());
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
        throw const ServerException(
          FirebaseErrorStrings.youHaveCancelledTheSigin,
        );
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
        throw const ServerException(FirebaseErrorStrings.userDataIsNull);
      }
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data()!);
      } else {
        final userData = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
        );
        await _firestore
            .collection("users")
            .doc(user.uid)
            .set(userData.toJson());
        return UserModel.fromJson(userData.toJson());
      }
    } on GoogleSignInException catch (e) {
      AppLogger.e(e.code.toString());
      throw ServerException(getGoogleSignInError(e));
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e.code);
      throw ServerException(getFirebaseError(e));
    } catch (e) {
      AppLogger.e(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<User?> userAuthStateChanges() async* {
    yield* firebaseAuth.authStateChanges().map((user) {
      return user;
    });
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

  @override
  Future<bool> updateFcmToken(String token) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw const ServerException(FirebaseErrorStrings.userDataIsNull);
      }
      final userDoc = _firestore.collection('users').doc(user.uid);
      await userDoc.update({
        'fcmToken': FieldValue.arrayUnion([token]),
      });
      return true;
    } catch (e) {
      AppLogger.e(e.toString());
      throw ServerException(e.toString());
    }
  }
}
