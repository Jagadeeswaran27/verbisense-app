import 'package:flutter/material.dart';

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/resources/common_strings.dart';
import 'package:verbisense/core/resources/icons.dart' as icons;
import 'package:verbisense/core/common/widgets/svg_loader.dart';
import 'package:verbisense/core/router/app_routes.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/utils/navigation.dart';
import 'package:verbisense/features/auth/presentation/widgets/custom_divider.dart';
import 'package:verbisense/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:verbisense/features/auth/presentation/widgets/form_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // widget.login(_userEmail, _userPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

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
                          onTap: _onLogin,
                          text: CommonStrings.login,
                        ),
                      ],
                    ),
                  ),
                ),
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
