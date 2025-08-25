import 'package:flutter/material.dart';

class IndicatorChip extends StatelessWidget {
  final String label;

  const IndicatorChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.black12),
      ),
    );
  }
}