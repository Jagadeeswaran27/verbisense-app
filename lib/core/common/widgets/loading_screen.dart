import 'package:flutter/material.dart';
import 'package:verbisense/core/common/widgets/loader/dots_tirangle.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: DotsTriangle(
          color: Colors.black,
          size: 60.0,
        ),
      ),
    );
  }
}
