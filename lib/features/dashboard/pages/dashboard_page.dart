import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lova/shared/widgets/app_scaffold.dart';
import 'package:lova/features/metrics/gauge_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Consumer(
        builder: (context, ref, _) {
          final gauge = ref.watch(gaugeProvider);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Dashboard",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text("Score de jauge : $gauge/100"),
              ],
            ),
          );
        },
      ),
    );
  }
}
