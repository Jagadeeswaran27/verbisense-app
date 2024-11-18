import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:verbisense/model/user_model.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserModel> getUser(String uid) async {
    final userDoc = await _firestore.collection("users").doc(uid).get();
    return UserModel.fromMap(userDoc.data()!);
  }

  Future<bool> updateUserName(String uid, String newUserName) async {
    try {
      await _firestore.collection("users").doc(uid).update({
        "userName": newUserName,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String?> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        return null;
      }
      return "";
    } catch (e) {
      print(e);
      return "false";
    }
  }

  Future<UserCredential?> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firestore.collection("users").doc(userCredential.user!.uid).set({
        "email": email,
        "userName": name,
      });
      return userCredential;
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      _firestore.collection("users").doc(userCredential.user!.uid).set({
        "email": userCredential.user!.email,
        "userName": userCredential.user!.displayName,
      });
      return userCredential;
    } catch (e) {
      return null;
    }
  }
}
