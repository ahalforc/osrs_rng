import 'package:flutter/material.dart';
import 'package:osrs_rng/features/activity_randomizer/activity_randomizer.dart';

class CustomActivityInput extends StatefulWidget {
  const CustomActivityInput({
    super.key,
    required this.isEnabled,
    required this.onAdd,
  });

  final bool isEnabled;
  final void Function(Activity) onAdd;

  @override
  State<CustomActivityInput> createState() => _CustomActivityInputState();
}

class _CustomActivityInputState extends State<CustomActivityInput> {
  final _activityController = TextEditingController();
  final _weightController = TextEditingController();
  final _activityFocusNode = FocusNode();
  final _weightFocusNode = FocusNode();

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
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            enabled: widget.isEnabled,
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
            enabled: widget.isEnabled,
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
          onPressed: widget.isEnabled ? _addEntry : null,
          icon: const Icon(Icons.add),
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
    _activityFocusNode.postFrameRequestFocus();

    widget.onAdd(Activity(activity, weight));
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
