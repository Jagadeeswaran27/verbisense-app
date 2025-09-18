import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/resources/common_strings.dart';
import 'package:verbisense/core/resources/icons.dart' as icons;
import 'package:verbisense/core/common/widgets/svg_loader.dart';
import 'package:verbisense/core/router/app_routes.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/utils/navigation.dart';
import 'package:verbisense/core/utils/show_snackbar.dart';
import 'package:verbisense/features/auth/presentation/provider/auth_provider.dart';
import 'package:verbisense/features/auth/presentation/widgets/custom_divider.dart';
import 'package:verbisense/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:verbisense/features/auth/presentation/widgets/form_input.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;
  String userEmail = '';
  String userPassword = '';

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _navigateToSignupScreen() {
    AppLogger.i('Navigating to Signup Screen');
    goToScreen(context, AppRoutes.signup.path);
  }

  void _clearInputs() {
    _formKey.currentState?.reset();
    setState(() {
      userEmail = '';
      userPassword = '';
    });
  }

  void _handleGoogleSignin() {
    ref.read(authProvider.notifier).signInWithGoogle();
    FocusScope.of(context).unfocus();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref
          .read(authProvider.notifier)
          .signIn(
            email: userEmail,
            password: userPassword,
          );
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthError) {
        showSnackBar(context, next.message, error: true);
      } else if (next is AuthSuccess) {
        showSnackBar(context, 'Welcome ${next.user.name}');
        _clearInputs();
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
                  height: 35,
                  width: 35,
                ),
                const SizedBox(height: 20),
                Text(
                  CommonStrings.loginIntoYourAccount,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        FormInput(
                          keyboardType: TextInputType.emailAddress,
                          suffixIcon: const Icon(Icons.email_outlined),
                          label: CommonStrings.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          onSaved: (value) => {userEmail = value!},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
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
                          autofillHints: const [AutofillHints.password],
                          onSaved: (value) => {userPassword = value!},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return CommonStrings.invalidPassword;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomElevatedButton(
                          onTap: _handleLogin,
                          text: CommonStrings.login,
                          loading: authState is AuthLoading,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const CustomDivider(),
                const SizedBox(height: 20),
                InkWell(
                  onTap: _handleGoogleSignin,
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
                      onTap: _navigateToSignupScreen,
                      child: Text(
                        CommonStrings.signup,
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
