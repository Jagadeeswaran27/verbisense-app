import 'package:flutter/material.dart';

import 'package:verbisense/core/widgets/common/svg_loader.dart';
import 'package:verbisense/core/resources/strings/common_strings.dart';
import 'package:verbisense/core/resources/icons.dart' as icons;
import 'package:verbisense/core/router/app_routes.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/utils/navigation.dart';
import 'package:verbisense/features/auth/presentation/widgets/custom_elevated_button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToLogin(BuildContext context) {
      pushToScreen(context, AppRoutes.login.path);
    }

    void navigateToSignup(BuildContext context) {
      pushToScreen(context, AppRoutes.signup.path);
    }

    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
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
                CommonStrings.welcomeString,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: screenSize.width * 0.7,
                child: Text(
                  textAlign: TextAlign.center,
                  CommonStrings.aiPowered,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                text: CommonStrings.login,
                icon: Icons.login,
                onTap: () => navigateToLogin(context),
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                text: CommonStrings.signup,
                icon: Icons.person_add_alt_outlined,
                backgroundColor: ThemeColors.white,
                onTap: () => navigateToSignup(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
