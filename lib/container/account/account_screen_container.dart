import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbisense/core/service/auth/auth_service.dart';
import 'package:verbisense/providers/auth_provider.dart';
import 'package:verbisense/resources/strings.dart';
import 'package:verbisense/widgets/account/account_screen_widget.dart';
import 'package:verbisense/widgets/common/custom_snackbar.dart';

class AccountScreenContainer extends StatefulWidget {
  const AccountScreenContainer({super.key});

  @override
  State<AccountScreenContainer> createState() => _AccountScreenContainerState();
}

class _AccountScreenContainerState extends State<AccountScreenContainer> {
  bool _isLoading = false;
  final authService = AuthService();

  void handleUpdateUserName(String name) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.userModel!.userName == name) {
      showCustomSnackBar(context, Strings.sameUserName, error: true);
      return;
    }

    final response = await authProvider.handleChangeName(name);
    if (response) {
      showCustomSnackBar(context, Strings.userNameUpdated);
    } else {
      showCustomSnackBar(context, Strings.userNameUpdateFailed);
    }
  }

  Future<bool> handleChangePassword(
      String currentPassword, String newPassword) async {
    setState(() {
      _isLoading = true;
    });
    final response =
        await authService.changePassword(currentPassword, newPassword);
    if (response == null) {
      showCustomSnackBar(context, Strings.passwordChanged);
      setState(() {
        _isLoading = false;
      });
      return true;
    } else {
      showCustomSnackBar(context, Strings.passwordChangeFailed, error: true);
      setState(() {
        _isLoading = false;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AccountScreenWidget(
      changePassword: handleChangePassword,
      changeUserName: handleUpdateUserName,
      isLoading: _isLoading,
    );
  }
}
