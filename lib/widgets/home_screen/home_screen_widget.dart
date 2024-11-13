import 'package:flutter/material.dart';
import 'package:verbisense/resources/icons.dart' as icons;
import 'package:verbisense/resources/strings.dart';
import 'package:verbisense/routes/routes.dart';
import 'package:verbisense/themes/colors.dart';
import 'package:verbisense/widgets/common/custom_elevated_button.dart';
import 'package:verbisense/widgets/common/svg_loader.dart';

class HomeScreenWidget extends StatelessWidget {
  const HomeScreenWidget({super.key});

  void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.login);
  }

  void navigateToSignup(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.signup);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: screenSize.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SVGLoader(image: icons.Icons.document),
              const SizedBox(height: 20),
              Text(
                Strings.welcomeString,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: screenSize.width * 0.7,
                child: Text(
                  textAlign: TextAlign.center,
                  Strings.aiPowered,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w100,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                text: Strings.login,
                icon: Icons.login,
                onTap: () => navigateToLogin(context),
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                text: Strings.signup,
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
