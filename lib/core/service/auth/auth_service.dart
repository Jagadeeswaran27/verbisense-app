import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
