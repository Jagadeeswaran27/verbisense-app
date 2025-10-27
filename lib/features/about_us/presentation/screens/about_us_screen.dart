import 'package:flutter/material.dart';

import 'package:verbisense/core/constants/about_us_data.dart';
import 'package:verbisense/core/resources/strings/common_strings.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/utils/navigation.dart';
import 'package:verbisense/features/about_us/presentation/widgets/about_us_detail_card.dart';
import 'package:verbisense/features/auth/presentation/widgets/custom_elevated_button.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(CommonStrings.about),
        shadowColor: ThemeColors.black.withOpacityValue(0.2),
        elevation: 4.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenSize.width * 0.85,
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      CommonStrings.currentCapabilites,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Wrap(
                  children: [
                    Text(
                      CommonStrings.currentCapabilitesDescription,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            height: 1.7,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                ...currentCapabilites.map((detail) {
                  return Column(
                    children: [
                      AboutUsDetailCard(
                        title: detail.title,
                        description: detail.description,
                        icon: detail.icon,
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  );
                }),
                Row(
                  children: [
                    Text(
                      CommonStrings.futureEnhancements,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Wrap(
                  children: [
                    Text(
                      CommonStrings.futureEnhancementsDescription,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            height: 1.7,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                ...futureEnhancements.map((detail) {
                  return Column(
                    children: [
                      AboutUsDetailCard(
                        title: detail.title,
                        description: detail.description,
                        icon: detail.icon,
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  );
                }),
                Text(
                  textAlign: TextAlign.center,
                  CommonStrings.joinUs,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16.0),
                Text(
                  CommonStrings.thankYouForChoosing,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 30.0),
                CustomElevatedButton(
                  onTap: () => popScreen(context),
                  text: CommonStrings.startExploringNow,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
