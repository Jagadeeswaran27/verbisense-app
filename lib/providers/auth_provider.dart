import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:verbisense/core/service/auth/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? user;
  AuthProvider() {
    _authService.authStateChanges.listen((User? newUser) {
      user = newUser;
      notifyListeners();
    });
  }
  bool get isAuthenticated => user != null;
}
