import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/core/providers/auth_core_provider.dart';
import 'package:verbisense/core/resources/strings/common_strings.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/widgets/common/focus_dismissable.dart';
import 'package:verbisense/features/account/presentation/providers/provider_info_provider.dart';
import 'package:verbisense/features/account/presentation/widgets/change_password_widget.dart';
import 'package:verbisense/features/account/presentation/widgets/google_user_avatar.dart';
import 'package:verbisense/features/account/presentation/widgets/personal_information.dart';
import 'package:verbisense/features/auth/presentation/widgets/custom_elevated_button.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  void _handleLogout() async {
    ref.read(authCoreProvider.notifier).signOut();
  }

  // void handleChangeName() {
  //   if (_updateNameKey.currentState!.validate()) {
  //     _updateNameKey.currentState!.save();
  //     ref.read(updateUserNameProvider.notifier).updateName(_userNameController.text);
  //   }
  //   _toggleNameEdit();
  // }

  @override
  Widget build(BuildContext context) {
    final accountUserProviderState = ref.watch(providerInfoProvider);

    final authCoreProviderState = ref.watch(authCoreProvider);

    final user = authCoreProviderState is AuthCoreSuccess
        ? authCoreProviderState.user
        : null;

    final bool isGoogleUser =
        accountUserProviderState is ProviderInfoLoaded &&
        accountUserProviderState.providers.contains('google.com');

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(CommonStrings.accountSettings),
        shadowColor: ThemeColors.black.withOpacityValue(0.2),
        elevation: 4.0,
      ),
      body: FocusDismissible(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (isGoogleUser && user != null) GoogleUserAvatar(user: user),
              PersonalInformation(
                isGoogleUser: isGoogleUser,
                user: user,
              ),
              const SizedBox(height: 24),
              if (!isGoogleUser) ChangePasswordWidget(),
              const SizedBox(height: 16),
              CustomElevatedButton(
                onTap: _handleLogout,
                text: CommonStrings.logout,
                icon: Icons.logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
