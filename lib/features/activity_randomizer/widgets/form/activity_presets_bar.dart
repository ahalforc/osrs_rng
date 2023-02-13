import 'package:flutter/material.dart';
import 'package:osrs_rng/features/activity_randomizer/activity_randomizer.dart';

class ActivityPresetsBar extends StatelessWidget {
  const ActivityPresetsBar({
    super.key,
    required this.selectedPreset,
    required this.onSelect,
  });

  final ActivityPreset selectedPreset;
  final void Function(ActivityPreset) onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final preset in ActivityPreset.values)
            Padding(
              padding: EdgeInsets.only(
                right: preset == ActivityPreset.values.last ? 0 : 8,
              ),
              child: ChoiceChip(
                label: Text(preset.label),
                selected: preset == selectedPreset,
                onSelected: (v) => onSelect(preset),
              ),
            ),
        ],
      ),
    );
  }
}
