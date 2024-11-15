import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:verbisense/core/service/auth/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? user;
  bool _isLoading = true;
  bool get isAuthenticated => user != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    Future.delayed(const Duration(seconds: 2), () {
      _initializeAuthState();
    });
  }

  void _initializeAuthState() {
    _authService.authStateChanges.listen((User? newUser) {
      user = newUser;
      _isLoading = false;
      notifyListeners();
    });
  }
}
