import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:osrs_rng/app/router.dart';
import 'package:osrs_rng/features/activity_randomizer/activity_randomizer.dart';
import 'package:osrs_rng/features/rng_simulator/rng_simulator.dart';

class Routes {
  static const home = '/';
  static const activityRandomizer = '/activity_randomizer';
  static const rngSimulator = '/rng_simulator';

  static RouterConfig<Object> routerConfig = GoRouter(
    errorBuilder: (_, __) {
      return const Scaffold(
        body: Center(
          child: Text('How did you get here...?\nGo somewhere else.'),
        ),
      );
    },
    routes: [
      GoRoute(
        path: home,
        builder: (_, __) => const Scaffold(),
        redirect: (_, __) => activityRandomizer,
      ),
      ShellRoute(
        builder: (context, state, child) {
          return Shell(
            route: state.location,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: activityRandomizer,
            builder: (_, __) => const ActivityRandomizerPage(),
            pageBuilder: (_, state) => const NoTransitionPage(
              child: ActivityRandomizerPage(),
            ),
          ),
          GoRoute(
            path: rngSimulator,
            builder: (_, __) => const RngSimulatorPage(),
            pageBuilder: (_, state) => const NoTransitionPage(
              child: RngSimulatorPage(),
            ),
          ),
        ],
      ),
    ],
  );
}
