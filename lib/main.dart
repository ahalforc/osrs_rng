import 'package:flutter/material.dart';
import 'package:osrs_rng/activity_randomizer/activity_randomizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'osrs rng',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const ActivityRandomizerPage(),
    );
  }
}
