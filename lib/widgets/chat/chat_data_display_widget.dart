import 'package:flutter/material.dart';

class ChatDataDisplayWidget extends StatelessWidget {
  const ChatDataDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height - kToolbarHeight - kBottomNavigationBarHeight,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Chat Data"),
            ],
          ),
        ),
      ),
    );
  }
}
