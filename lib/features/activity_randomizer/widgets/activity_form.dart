import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:osrs_rng/features/activity_randomizer/activity_randomizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({super.key, required this.onSubmit});

  final void Function(List<Activity>) onSubmit;

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  static const _localStorageKey = 'activities';

  final _activities = <Activity>[];
  var _preset = ActivityPreset.custom;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: min(constraints.maxWidth, 400),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ActivityPresetsBar(
                  selectedPreset: _preset,
                  onSelect: _onSelectPreset,
                ),
                const SizedBox(height: 16),
                ActivityList(
                  activities: _activities,
                  isReadOnly: _preset != ActivityPreset.custom,
                  onRemove: _onRemove,
                ),
                const SizedBox(height: 16),
                CustomActivityInput(
                  isEnabled: _preset == ActivityPreset.custom,
                  onAdd: _onAdd,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _activities.length < 2
                      ? null
                      : () => widget.onSubmit(_activities),
                  child: const Text('To the wheel!'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_localStorageKey);
    if (json != null) {
      final decoded = jsonDecode(json);
      if (!mounted) return;
      setState(() {
        for (final entry in decoded) {
          _activities.add(Activity.fromJson(entry));
        }
      });
    }
  }

  void _save() async {
    if (_preset != ActivityPreset.custom) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_localStorageKey, jsonEncode(_activities));
  }

  void _onSelectPreset(ActivityPreset preset) {
    setState(() {
      _preset = preset;
      _activities
        ..clear()
        ..addAll(preset.activities);
    });
    if (preset == ActivityPreset.custom) {
      _load();
    }
  }

  void _onAdd(Activity activity) {
    setState(() => _activities.add(activity));
    _save();
  }

  void _onRemove(Activity activity) {
    setState(() => _activities.remove(activity));
    _save();
  }
}
