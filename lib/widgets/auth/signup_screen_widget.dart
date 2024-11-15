import 'package:flutter/material.dart';
import 'package:verbisense/resources/regex.dart';
import 'package:verbisense/resources/strings.dart';
import 'package:verbisense/routes/routes.dart';
import 'package:verbisense/themes/colors.dart';
import 'package:verbisense/widgets/common/custom_divider.dart';
import 'package:verbisense/widgets/common/custom_elevated_button.dart';
import 'package:verbisense/widgets/common/form_input.dart';
import 'package:verbisense/widgets/common/svg_loader.dart';
import 'package:verbisense/resources/icons.dart' as icons;

class SignupScreenWidget extends StatefulWidget {
  const SignupScreenWidget({
    super.key,
    required this.signup,
    required this.isLoading,
    required this.googleLogin,
  });

  final void Function(String name, String email, String password) signup;
  final void Function() googleLogin;

  final bool isLoading;

  @override
  State<SignupScreenWidget> createState() => _SignupScreenWidgetState();
}

class _SignupScreenWidgetState extends State<SignupScreenWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;
  String _userEmail = '';
  String _userPassword = '';
  String _userName = '';

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.signup(_userName, _userEmail, _userPassword);
    }
  }

  void _navigateToLoginScreen() {
    Navigator.of(context).pushReplacementNamed(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SizedBox(
          width: screenSize.width * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SVGLoader(image: icons.Icons.document),
              const SizedBox(height: 20),
              Text(
                Strings.createYourAccount,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    FormInput(
                      keyboardType: TextInputType.name,
                      label: Strings.fullName,
                      onSaved: (value) => {_userName = value!},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Strings.invalidName;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    FormInput(
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: const Icon(Icons.email_outlined),
                      label: Strings.emailAddress,
                      onSaved: (value) => {_userEmail = value!},
                      validator: (value) {
                        final emailPattern = RegExp(Regex.emailRegEx);

                        if (value == null ||
                            value.isEmpty ||
                            !emailPattern.hasMatch(value)) {
                          return Strings.invalidEmailOrPhone;
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
                      label: Strings.password,
                      obscureText: _isPasswordVisible,
                      onSaved: (value) => {_userPassword = value!},
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return Strings.invalidPassword;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                      onTap: widget.isLoading ? () => {} : _handleSignup,
                      text: widget.isLoading ? Strings.loading : Strings.signup,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const CustomDivider(),
              const SizedBox(height: 20),
              InkWell(
                onTap: widget.googleLogin,
                child: const SVGLoader(image: icons.Icons.google),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Strings.dontHaveAnAccount,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: ThemeColors.black200,
                        ),
                  ),
                  InkWell(
                    onTap: _navigateToLoginScreen,
                    child: Text(
                      Strings.login,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
