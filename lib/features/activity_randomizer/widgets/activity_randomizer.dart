import 'dart:math';

import 'package:flutter/material.dart';
import 'package:osrs_rng/features/activity_randomizer/activity_randomizer.dart';

class ActivityRandomizer extends StatefulWidget {
  const ActivityRandomizer({
    super.key,
    required this.activities,
    required this.onLeave,
  });

  final List<Activity> activities;
  final void Function() onLeave;

  @override
  State<ActivityRandomizer> createState() => _ActivityRandomizerState();
}

class _ActivityRandomizerState extends State<ActivityRandomizer> {
  var _rollTarget = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: () => setState(
                () => _rollTarget = Random().nextDouble() * 2 * pi,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final diameter =
                      min(constraints.maxWidth, constraints.maxHeight) - 64;
                  return SizedBox(
                    width: diameter,
                    height: diameter,
                    child: Stack(
                      children: [
                        const WheelBackground(),
                        for (final activity in widget.activities)
                          ActivitySlice(
                            key: ValueKey(activity),
                            activity: activity,
                            activities: widget.activities,
                            radius: diameter / 2,
                          ),
                        _Spinner(
                          radius: diameter / 2,
                          angle: _rollTarget,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: widget.onLeave,
            child: const Text('No wait go back'),
          ),
        )
      ],
    );
  }
}

class _Spinner extends StatefulWidget {
  const _Spinner({required this.radius, required this.angle});

  final double radius, angle;

  @override
  State<_Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<_Spinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  var _lastAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _Spinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    _lastAngle = oldWidget.angle;
    _controller.reset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    const spins = 10;

    final length = widget.radius * 0.5;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Center(
          child: Transform.rotate(
            angle: Tween(
              begin: _lastAngle,
              end: (spins * 2 * pi) + widget.angle,
            ).evaluate(_animation),
            child: Transform.translate(
              offset: Offset(
                length / 2,
                -length / 2,
              ),
              // offset: Offset.zero,
              child: Container(
                alignment: Alignment.bottomLeft,
                width: length,
                height: length,
                child: Image.asset(
                  'assets/osrs_dragon_scimitar.webp',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
