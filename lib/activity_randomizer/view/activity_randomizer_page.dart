import 'package:flutter/material.dart';
import 'package:osrs_rng/activity_randomizer/activity_randomizer.dart';

class ActivityRandomizerPage extends StatefulWidget {
  const ActivityRandomizerPage({super.key});

  @override
  State<ActivityRandomizerPage> createState() => _ActivityRandomizerPageState();
}

class _ActivityRandomizerPageState extends State<ActivityRandomizerPage> {
  final _activities = <Activity>[];
  var _showForm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 750),
          switchInCurve: Curves.elasticOut,
          reverseDuration: const Duration(milliseconds: 100),
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) => SlideTransition(
            position: Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
          child: _showForm
              ? ActivityForm(
                  onSubmit: (activities) {
                    setState(() {
                      _showForm = false;
                      _activities
                        ..clear()
                        ..addAll(activities);
                    });
                  },
                )
              : ActivityRandomizer(
                  activities: _activities,
                  onLeave: () => setState(() => _showForm = true),
                ),
        ),
      ),
    );
  }
}
