import 'package:flutter/material.dart';
import 'package:osrs_rng/app/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'osrs rng',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      routerConfig: Routes.routerConfig,
    );
  }
}
