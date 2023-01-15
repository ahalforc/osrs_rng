import 'package:flutter/material.dart';
import 'package:osrs_rng/activity_randomizer/activity_randomizer.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({
    super.key,
    required this.activities,
    required this.onRemove,
  });

  final List<Activity> activities;
  final void Function(Activity) onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          for (final activity in activities)
            ActivityListTile(
              activity: activity,
              onRemove: () => onRemove(activity),
            ),
        ],
      ),
    );
  }
}

class ActivityListTile extends StatelessWidget {
  const ActivityListTile({
    super.key,
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
