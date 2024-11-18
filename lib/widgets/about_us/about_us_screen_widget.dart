import 'package:flutter/material.dart';
import 'package:verbisense/resources/strings.dart';
import 'package:verbisense/utils/about_us_data.dart';
import 'package:verbisense/widgets/about_us/about_us_detail_card.dart';
import 'package:verbisense/widgets/common/custom_elevated_button.dart';

class AboutUsScreenWidget extends StatelessWidget {
  const AboutUsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(Strings.about),
        shadowColor: Colors.black.withOpacity(0.2),
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
                      Strings.currentCapabilites,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Wrap(
                  children: [
                    Text(
                      Strings.currentCapabilitesDescription,
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
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
                      Strings.futureEnhancements,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Wrap(
                  children: [
                    Text(
                      Strings.futureEnhancementsDescription,
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
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
                  Strings.joinUs,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16.0),
                Text(
                  Strings.thankYouForChoosing,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 30.0),
                CustomElevatedButton(
                  onTap: () => {Navigator.of(context).pop()},
                  text: Strings.startExploringNow,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
