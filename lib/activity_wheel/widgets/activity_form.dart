import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:osrs_rng/activity_wheel/activity_wheel.dart';
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
  final _activityController = TextEditingController();
  final _weightController = TextEditingController();
  final _activityFocusNode = FocusNode();
  final _weightFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _load();
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
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_localStorageKey, jsonEncode(_activities));
  }

  @override
  void dispose() {
    _activityController.dispose();
    _weightController.dispose();
    _activityFocusNode.dispose();
    _weightFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ActivityFormContainer(
      children: [
        const Text('Add some activities'),
        if (_activities.isNotEmpty) ...[
          const SizedBox(height: 16),
          _ActivityList(
            activities: _activities,
            onRemove: _removeEntry,
          ),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: _activityController,
                focusNode: _activityFocusNode,
                onSubmitted: (_) => _addEntry(),
                decoration: const InputDecoration(
                  labelText: 'activity name',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _weightController,
                focusNode: _weightFocusNode,
                onSubmitted: (_) => _addEntry(),
                decoration: const InputDecoration(
                  labelText: 'weight',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: _addEntry,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _activities.length < 2
              ? null
              : () => widget.onSubmit(_activities),
          child: const Text('Submit'),
        ),
      ],
    );
  }

  void _addEntry() {
    final activity = _activityController.text;
    if (activity.isEmpty) {
      context.showSnackBar('You need an activity');
      _activityFocusNode.postFrameRequestFocus();
      return;
    }

    final weight = int.tryParse(_weightController.text) ?? 0;
    if (weight < 1) {
      context.showSnackBar('You need a positive weight');
      _weightFocusNode.postFrameRequestFocus();
      return;
    }

    _activityController.clear();
    _weightController.clear();
    setState(() => _activities.add(Activity(activity, weight)));
    _activityFocusNode.postFrameRequestFocus();

    _save();
  }

  void _removeEntry(Activity activity) {
    setState(
      () => _activities.remove(activity),
    );
    _save();
  }
}

class _ActivityFormContainer extends StatelessWidget {
  const _ActivityFormContainer({required this.children});

  final List<Widget> children;

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
              children: children,
            ),
          ),
        );
      },
    );
  }
}

class _ActivityList extends StatelessWidget {
  const _ActivityList({
    required this.activities,
    required this.onRemove,
  });

  final List<Activity> activities;
  final void Function(Activity) onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 400,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final activity in activities)
              _ActivityListTile(
                activity: activity,
                onRemove: () => onRemove(activity),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActivityListTile extends StatelessWidget {
  const _ActivityListTile({
    required this.activity,
    required this.onRemove,
  });

  final Activity activity;
  final void Function() onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(activity.name),
      subtitle: Text('Weight: ${activity.weight}'),
      trailing: IconButton(
        onPressed: onRemove,
        icon: const Icon(Icons.remove),
      ),
    );
  }
}

extension on BuildContext {
  void showSnackBar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}

extension on FocusNode {
  void postFrameRequestFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestFocus();
    });
  }
}
