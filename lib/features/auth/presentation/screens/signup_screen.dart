import 'package:flutter/material.dart';

import 'package:verbisense/core/common/widgets/svg_loader.dart';
import 'package:verbisense/core/resources/common_strings.dart';
import 'package:verbisense/core/resources/regex.dart';
import 'package:verbisense/core/router/app_routes.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/utils/navigation.dart';
import 'package:verbisense/core/resources/icons.dart' as icons;
import 'package:verbisense/features/auth/presentation/widgets/custom_divider.dart';
import 'package:verbisense/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:verbisense/features/auth/presentation/widgets/form_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // widget.signup(_userName, _userEmail, _userPassword);
    }
  }

  void _navigateToLoginScreen() {
    goToScreen(context, AppRoutes.login.path);
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
