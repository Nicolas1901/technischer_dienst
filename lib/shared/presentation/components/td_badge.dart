import 'package:flutter/material.dart';

class TdBadge extends StatelessWidget {
  final String label;
  final Color color;

  const TdBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        border: Border.all(color: color, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Text(
        label,
        textScaler: TextScaler.linear(0.7),
      ),
    );
  }
}
