import 'package:flutter/material.dart';
import 'package:osrs_rng/activity_wheel/activity_wheel.dart';

class ActivityWheelPage extends StatefulWidget {
  const ActivityWheelPage({super.key});

  @override
  State<ActivityWheelPage> createState() => _ActivityWheelPageState();
}

class _ActivityWheelPageState extends State<ActivityWheelPage> {
  final _activities = <Activity>[];
  var _showForm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: const FractionalOffset(0.5, 0.4),
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
            : ActivityWheel(
                activities: _activities,
                onLeave: () => setState(() => _showForm = true),
              ),
      ),
    );
  }
}
