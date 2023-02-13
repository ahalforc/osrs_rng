import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:osrs_rng/app/router.dart';

class Shell extends StatefulWidget {
  const Shell({
    super.key,
    required this.route,
    required this.child,
  });

  final String? route;
  final Widget child;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  static const _destinations = [
    _ShellDestination(
      route: Routes.activityRandomizer,
      destination: NavigationRailDestination(
        icon: Text('RNG'),
        label: Text('Activity Randomizer'),
      ),
    ),
    _ShellDestination(
      route: Routes.rngSimulator,
      destination: NavigationRailDestination(
        icon: Text('SIM'),
        label: Text('Drop Simulator'),
      ),
    ),
  ];

  var _selectedIndex = 0;

  @override
  void didUpdateWidget(covariant Shell oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _selectedIndex = _destinations.firstIndexWhere(
            (sd) => sd.route == widget.route,
          ) ??
          0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: false,
            selectedIndex: _selectedIndex,
            destinations: _destinations.map((sd) => sd.destination).toList(),
            onDestinationSelected: (i) => _onSelected(context, i),
          ),
          const VerticalDivider(),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }

  void _onSelected(BuildContext context, int i) {
    // setState(() {
    //   _selectedIndex = i;
    // });
    switch (i) {
      case 0:
        context.go(Routes.activityRandomizer);
        break;
      case 1:
        context.go(Routes.rngSimulator);
        break;
    }
  }
}

class _ShellDestination {
  final String route;
  final NavigationRailDestination destination;
  const _ShellDestination({required this.route, required this.destination});
}

extension on List<_ShellDestination> {
  int? firstIndexWhere(bool Function(_ShellDestination) test) {
    for (var i = 0; i < length; i++) {
      if (test(this[i])) return i;
    }
    return null;
  }
}
