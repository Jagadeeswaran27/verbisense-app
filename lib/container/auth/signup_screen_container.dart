import 'package:flutter/material.dart';
import 'package:verbisense/core/service/auth/auth_service.dart';
import 'package:verbisense/resources/strings.dart';
import 'package:verbisense/routes/routes.dart';
import 'package:verbisense/widgets/auth/signup_screen_widget.dart';
import 'package:verbisense/widgets/common/custom_snackbar.dart';

class SignupScreenContainer extends StatefulWidget {
  const SignupScreenContainer({super.key});

  @override
  State<SignupScreenContainer> createState() => _SignupScreenContainerState();
}

class _SignupScreenContainerState extends State<SignupScreenContainer> {
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
    } else {
      showCustomSnackBar(context, Strings.googleLoginFailed, error: true);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void handleSignup(String name, String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    final userCredential = await authService.signUp(name, email, password);
    if (userCredential != null) {
      await userCredential.user!.sendEmailVerification();
      showCustomSnackBar(context, Strings.emailVerificationSent);
      Navigator.of(context).pushReplacementNamed(
        Routes.login,
      );
    } else {
      showCustomSnackBar(context, Strings.accountAlreadyExists, error: true);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SignupScreenWidget(
      isLoading: _isLoading,
      googleLogin: handleGoogleLogin,
      signup: handleSignup,
    );
  }
}
