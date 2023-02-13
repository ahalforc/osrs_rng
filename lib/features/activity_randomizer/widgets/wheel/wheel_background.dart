import 'package:flutter/material.dart';

class WheelBackground extends StatelessWidget {
  const WheelBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
