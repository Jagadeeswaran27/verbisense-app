import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/core/common/widgets/svg_loader.dart';
import 'package:verbisense/core/resources/common_strings.dart';
import 'package:verbisense/core/resources/regex.dart';
import 'package:verbisense/core/router/app_routes.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/utils/navigation.dart';
import 'package:verbisense/core/resources/icons.dart' as icons;
import 'package:verbisense/core/utils/show_snackbar.dart';
import 'package:verbisense/features/auth/presentation/provider/auth_provider.dart';
import 'package:verbisense/features/auth/presentation/widgets/custom_divider.dart';
import 'package:verbisense/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:verbisense/features/auth/presentation/widgets/form_input.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;
  String userEmail = '';
  String userPassword = '';
  String userName = '';

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _clearInputs() {
    _formKey.currentState?.reset();
    setState(() {
      userEmail = '';
      userPassword = '';
      userName = '';
    });
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref
          .read(authProvider.notifier)
          .signUp(
            name: userName,
            email: userEmail,
            password: userPassword,
          );
    }
  }

  void _navigateToLoginScreen() {
    goToScreen(context, AppRoutes.login.path);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthError) {
        final snackBar = SnackBar(
          content: Text(next.message),
          backgroundColor: ThemeColors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (next is AuthSuccess) {
        showSnackBar(context, 'Signup Success!');
        _clearInputs();
        _navigateToLoginScreen();
        // Navigate to home or another screen if needed
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: SizedBox(
            width: screenSize.width * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SVGLoader(
                  image: icons.Icons.documentIcon,
                  width: 35,
                  height: 35,
                ),
                const SizedBox(height: 20),
                Text(
                  CommonStrings.createYourAccount,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormInput(
                        keyboardType: TextInputType.name,
                        label: CommonStrings.fullName,
                        onSaved: (value) => {userName = value!},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return CommonStrings.invalidName;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      FormInput(
                        keyboardType: TextInputType.emailAddress,
                        suffixIcon: const Icon(Icons.email_outlined),
                        label: CommonStrings.emailAddress,
                        onSaved: (value) => {userEmail = value!},
                        validator: (value) {
                          final emailPattern = RegExp(Regex.emailRegEx);

                          if (value == null ||
                              value.isEmpty ||
                              !emailPattern.hasMatch(value)) {
                            return CommonStrings.invalidEmailOrPhone;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      FormInput(
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: InkWell(
                          onTap: _togglePasswordVisibility,
                          child: _isPasswordVisible
                              ? const Icon(Icons.visibility_off_outlined)
                              : const Icon(Icons.remove_red_eye_outlined),
                        ),
                        label: CommonStrings.password,
                        obscureText: _isPasswordVisible,
                        onSaved: (value) => {userPassword = value!},
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6) {
                            return CommonStrings.invalidPassword;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomElevatedButton(
                        onTap: _handleSignup,
                        text: CommonStrings.signup,
                      ),
                    ],
                  ),
                ),
                if (authState is AuthLoading) ...[
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                ],
                const SizedBox(height: 20),
                const CustomDivider(),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {},
                  child: const SVGLoader(
                    image: icons.Icons.googleIcon,
                    width: 35,
                    height: 35,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      CommonStrings.dontHaveAnAccount,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: ThemeColors.black200,
                          ),
                    ),
                    InkWell(
                      onTap: _navigateToLoginScreen,
                      child: Text(
                        CommonStrings.login,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
