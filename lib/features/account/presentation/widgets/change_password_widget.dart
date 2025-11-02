import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/core/resources/strings/common_strings.dart';
import 'package:verbisense/core/utils/show_snackbar.dart';
import 'package:verbisense/features/account/presentation/providers/change_password_provider.dart';
import 'package:verbisense/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:verbisense/features/auth/presentation/widgets/form_input.dart';

class ChangePasswordWidget extends ConsumerStatefulWidget {
  const ChangePasswordWidget({super.key});

  @override
  ConsumerState<ChangePasswordWidget> createState() =>
      _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends ConsumerState<ChangePasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  String _newPassword = '';
  bool _isCurrentPasswordVisible = true;
  bool _isNewPasswordVisible = true;

  void _toggleCurrentPasswordVisibility() {
    setState(() {
      _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _isNewPasswordVisible = !_isNewPasswordVisible;
    });
  }

  void _handleFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref
          .read(changePasswordProvider.notifier)
          .changePassword(
            _currentPassword,
            _newPassword,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final changePasswordState = ref.watch(changePasswordProvider);

    ref.listen<ChangePasswordState>(
      changePasswordProvider,
      (previous, state) {
        if (state is ChangePasswordFailure) {
          showSnackBar(context, state.error, error: true);
        } else if (state is ChangePasswordSuccess) {
          showSnackBar(context, state.message);
        }
      },
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_outline),
              const SizedBox(width: 8),
              Text(
                CommonStrings.changePassword,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(CommonStrings.currentPassword),
          const SizedBox(height: 8),
          FormInput(
            onSaved: (value) => _currentPassword = value!,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return CommonStrings.invalidPassword;
              }
              return null;
            },
            suffixIcon: _isCurrentPasswordVisible
                ? const Icon(Icons.visibility_off_outlined)
                : const Icon(Icons.remove_red_eye_outlined),
            onIconTap: _toggleCurrentPasswordVisibility,
            obscureText: _isCurrentPasswordVisible,
          ),
          const SizedBox(height: 16),
          const Text(CommonStrings.newPassword),
          const SizedBox(height: 8),
          FormInput(
            obscureText: _isNewPasswordVisible,
            onSaved: (value) => _newPassword = value!,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return CommonStrings.invalidPassword;
              }
              return null;
            },
            suffixIcon: _isCurrentPasswordVisible
                ? const Icon(Icons.visibility_off_outlined)
                : const Icon(Icons.remove_red_eye_outlined),
            onIconTap: _toggleNewPasswordVisibility,
          ),
          const SizedBox(height: 24),
          CustomElevatedButton(
            onTap: _handleFormSubmit,
            text: CommonStrings.changePassword,
            icon: Icons.save,
            loading: changePasswordState is ChangePasswordLoading,
          ),
        ],
      ),
    );
  }
}
