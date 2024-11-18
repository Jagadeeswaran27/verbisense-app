import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbisense/core/service/auth/auth_service.dart';
import 'package:verbisense/providers/auth_provider.dart';
import 'package:verbisense/resources/strings.dart';
import 'package:verbisense/routes/routes.dart';
import 'package:verbisense/widgets/common/custom_elevated_button.dart';
import 'package:verbisense/widgets/common/form_input.dart';

class AccountScreenWidget extends StatefulWidget {
  const AccountScreenWidget({
    super.key,
    required this.changePassword,
    required this.isLoading,
    required this.changeUserName,
  });

  final Future<bool> Function(String currentPassword, String newPassword)
      changePassword;
  final void Function(String name) changeUserName;
  final bool isLoading;

  @override
  State<AccountScreenWidget> createState() => _AccountScreenWidgetState();
}

class _AccountScreenWidgetState extends State<AccountScreenWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _isNameEditable = false;
  bool _isCurrentPasswordVisible = true;
  String _currentPassword = '';
  String _newPassword = '';
  final authService = AuthService();

  final TextEditingController _userNameController = TextEditingController();

  void _handleLogout() async {
    await authService.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.init,
      (Route<dynamic> route) => false,
    );
  }

  void _toggleNameEdit() {
    setState(() {
      _isNameEditable = !_isNameEditable;
    });
  }

  void _toggleCurrentPasswordVisibility() {
    setState(() {
      _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
    });
  }

  void handleChangeName() {
    widget.changeUserName(_userNameController.text);
    _toggleNameEdit();
  }

  void _handleFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response =
          await widget.changePassword(_currentPassword, _newPassword);
      if (response) {
        _formKey.currentState!.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    _userNameController.text = authProvider.userModel?.userName ?? '';

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(Strings.accountSettings),
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 4.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (authProvider.isGoogleUser)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  authProvider.user?.photoURL != null
                      ? CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              NetworkImage(authProvider.user!.photoURL!),
                        )
                      : const Icon(
                          Icons.account_circle,
                          size: 50.0,
                        ),
                  const SizedBox(height: 16),
                ],
              ),
            Row(
              children: [
                const Icon(Icons.person_outline),
                const SizedBox(width: 8),
                Text(
                  Strings.personalInformation,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(Strings.name),
                const SizedBox(height: 8),
                FormInput(
                  controller: _userNameController,
                  readOnly: !_isNameEditable,
                  suffixIcon: !authProvider.isGoogleUser
                      ? _isNameEditable
                          ? GestureDetector(
                              onTap: handleChangeName,
                              child: const Icon(Icons.check),
                            )
                          : GestureDetector(
                              onTap: _toggleNameEdit,
                              child: const Icon(Icons.edit),
                            )
                      : null,
                ),
                const SizedBox(height: 16),
                const Text(Strings.emailAddress),
                const SizedBox(height: 8),
                FormInput(
                  readOnly: true,
                  initialValue: authProvider.userModel?.email,
                ),
                const SizedBox(height: 24),
              ],
            ),
            if (!authProvider.isGoogleUser)
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lock_outline),
                        const SizedBox(width: 8),
                        Text(
                          Strings.changePassword,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(Strings.currentPassword),
                    const SizedBox(height: 8),
                    FormInput(
                      onSaved: (value) => _currentPassword = value!,
                      validator: (p0) => p0 == null || p0.isEmpty
                          ? Strings.invalidPassword
                          : null,
                      suffixIcon: _isCurrentPasswordVisible
                          ? const Icon(Icons.visibility_off_outlined)
                          : const Icon(Icons.remove_red_eye_outlined),
                      onIconTap: _toggleCurrentPasswordVisibility,
                      obscureText: _isCurrentPasswordVisible,
                    ),
                    const SizedBox(height: 16),
                    const Text(Strings.newPassword),
                    const SizedBox(height: 8),
                    FormInput(
                      obscureText: true,
                      onSaved: (value) => _newPassword = value!,
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return Strings.invalidPassword;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomElevatedButton(
                      onTap: _handleFormSubmit,
                      text: widget.isLoading
                          ? Strings.loading
                          : Strings.changePassword,
                      icon: Icons.save,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            CustomElevatedButton(
              onTap: _handleLogout,
              text: Strings.logout,
              icon: Icons.logout,
            )
          ],
        ),
      ),
    );
  }
}
