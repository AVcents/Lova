import 'package:flutter/material.dart';
import '../../shared/widgets/app_scaffold.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: Center(
        child: Text("Onboarding Page"),
      ),
    );
  }
}