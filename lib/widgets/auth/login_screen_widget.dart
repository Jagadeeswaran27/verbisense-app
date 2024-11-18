import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verbisense/core/service/autofill/autofill_service.dart';
import 'package:verbisense/resources/strings.dart';
import 'package:verbisense/routes/routes.dart';
import 'package:verbisense/themes/colors.dart';
import 'package:verbisense/widgets/common/custom_divider.dart';
import 'package:verbisense/widgets/common/custom_elevated_button.dart';
import 'package:verbisense/widgets/common/form_input.dart';
import 'package:verbisense/widgets/common/svg_loader.dart';
import 'package:verbisense/resources/icons.dart' as icons;

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({
    super.key,
    required this.login,
    required this.googleLogin,
    required this.isLoading,
  });

  final void Function(String email, String password) login;
  final void Function() googleLogin;
  final bool isLoading;

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AutofillService _autofillService = AutofillService();
  bool _isPasswordVisible = true;
  String _userEmail = '';
  String _userPassword = '';

  @override
  void initState() {
    super.initState();
    _setupAutofill();
  }

  Future<void> _setupAutofill() async {
    await _autofillService.setupAutofill(
      _emailController,
      [AutofillHints.email, AutofillHints.username],
    );
    await _autofillService.setupAutofill(
      _passwordController,
      [AutofillHints.password],
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _navigateToSignupScreen() {
    Navigator.of(context).pushReplacementNamed(Routes.signup);
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.login(_userEmail, _userPassword);
      TextInput.finishAutofillContext(shouldSave: true);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                Strings.loginIntoYourAccount,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    children: [
                      FormInput(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        suffixIcon: const Icon(Icons.email_outlined),
                        label: Strings.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        onSaved: (value) => {_userEmail = value!},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
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
                        autofillHints: const [AutofillHints.password],
                        onSaved: (value) => {_userPassword = value!},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return Strings.invalidPassword;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomElevatedButton(
                        onTap: widget.isLoading ? () => {} : _onLogin,
                        text:
                            widget.isLoading ? Strings.loading : Strings.login,
                      ),
                    ],
                  ),
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
                    onTap: _navigateToSignupScreen,
                    child: Text(
                      Strings.signup,
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
