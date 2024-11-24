import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:verbisense/core/service/auth/auth_service.dart';
import 'package:verbisense/model/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? user;
  UserModel? userModel;
  bool _isLoading = true;
  String currentThread = 'Today';

  bool get isAuthenticated => user != null;
  bool get isLoading => _isLoading;

  bool get isGoogleUser {
    if (user == null) return false;
    return user!.providerData.any((info) => info.providerId == 'google.com');
  }

  AuthProvider() {
    Future.delayed(const Duration(seconds: 2), () {
      _initializeAuthState();
    });
  }

  void _initializeAuthState() {
    _authService.authStateChanges.listen((User? newUser) async {
      _isLoading = true;
      notifyListeners();

      user = newUser;
      if (newUser != null) {
        try {
          userModel = await _authService.getUser(newUser.uid);
        } catch (e) {
          userModel = null;
        }
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<bool> handleChangeName(String name) async {
    try {
      final response = await _authService.updateUserName(user!.uid, name);
      if (response) {
        final newUserModel = UserModel(
          email: userModel!.email,
          userName: name,
        );
        userModel = newUserModel;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
