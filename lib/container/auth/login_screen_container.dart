import 'package:flutter/material.dart';
import 'package:verbisense/core/service/auth/auth_service.dart';
import 'package:verbisense/resources/strings.dart';
import 'package:verbisense/routes/routes.dart';
import 'package:verbisense/widgets/auth/login_screen_widget.dart';
import 'package:verbisense/widgets/common/custom_snackbar.dart';

class LoginScreenContainer extends StatefulWidget {
  const LoginScreenContainer({super.key});

  @override
  State<LoginScreenContainer> createState() => _LoginScreenContainerState();
}

class _LoginScreenContainerState extends State<LoginScreenContainer> {
  bool _isLoading = false;
  final authService = AuthService();

  void handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
    });
    final userCredential = await authService.signInWithGoogle();
    if (userCredential != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.chat,
        (Route<dynamic> route) => false,
      );
      showCustomSnackBar(context, Strings.loginSuccessFull);
    } else {
      showCustomSnackBar(context, Strings.googleLoginFailed, error: true);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    final userCredential = await authService.login(email, password);
    if (userCredential != null) {
      if (!userCredential.user!.emailVerified) {
        showCustomSnackBar(context, Strings.verifyYourEmail, error: true);
        setState(() {
          _isLoading = false;
        });
        return;
      }
      showCustomSnackBar(context, Strings.loginSuccessFull);
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.chat,
        (Route<dynamic> route) => false,
      );
    } else {
      showCustomSnackBar(context, Strings.invalidCredentials, error: true);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginScreenWidget(
      googleLogin: handleGoogleLogin,
      login: handleLogin,
      isLoading: _isLoading,
    );
  }
}
