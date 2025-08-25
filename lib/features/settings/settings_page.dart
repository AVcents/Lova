import 'package:flutter/material.dart';
import '../../shared/widgets/app_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: Center(
        child: Text("Settings Page"),
      ),
    );
  }
}