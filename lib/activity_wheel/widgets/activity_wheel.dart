import 'dart:math';

import 'package:flutter/material.dart';
import 'package:osrs_rng/activity_wheel/activity_wheel.dart';

class ActivityWheel extends StatefulWidget {
  const ActivityWheel({
    super.key,
    required this.activities,
    required this.onLeave,
  });

  final List<Activity> activities;
  final void Function() onLeave;

  @override
  State<ActivityWheel> createState() => _ActivityWheelState();
}

class _ActivityWheelState extends State<ActivityWheel> {
  var _rollTarget = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _rollTarget = Random().nextDouble() * 2 * pi),
      onLongPress: widget.onLeave,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final diameter =
              min(constraints.maxWidth, constraints.maxHeight) - 64;
          return SizedBox(
            width: diameter,
            height: diameter,
            child: Stack(
              children: [
                const _Wheel(),
                for (final activity in widget.activities)
                  _Slice(
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
  late final Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
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
    _controller.reset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Center(
          child: Transform.rotate(
            angle: widget.angle * _animation.value,
            child: Transform.translate(
              offset: Offset(widget.radius * 0.75 / 2, 0),
              child: Container(
                width: widget.radius * 0.75,
                height: 10,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Wheel extends StatelessWidget {
  const _Wheel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class _Slice extends StatelessWidget {
  const _Slice({
    super.key,
    required this.activity,
    required this.activities,
    required this.radius,
  });

  final Activity activity;
  final List<Activity> activities;
  final double radius;

  int get _weightOffset =>
      activities.sublist(0, activities.indexOf(activity)).totalWeight;

  @override
  Widget build(BuildContext context) {
    assert(activity.weight < activities.totalWeight);

    final offsetRadians = _weightOffset / activities.totalWeight * 2 * pi;
    final radians = activity.weight / activities.totalWeight * 2 * pi;

    final assetPath = activity.assetPath;

    return CustomPaint(
      foregroundPainter: _SliceBorderPainter(
        startRadians: offsetRadians,
        endRadians: offsetRadians + radians,
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: ClipPath(
        clipper: _SliceClipper(
          startRadians: offsetRadians,
          endRadians: offsetRadians + radians,
        ),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: Transform(
            transform: Matrix4.identity()
              ..translate(
                radius / 2 * cos(offsetRadians + radians / 2),
                radius / 2 * sin(offsetRadians + radians / 2),
              ),
            child: assetPath == null
                ? Text(
                    activity.name,
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                : Image.asset(
                    assetPath,
                    width: radius,
                    height: radius,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }
}

class _SliceClipper extends CustomClipper<Path> {
  _SliceClipper({
    required this.startRadians,
    required this.endRadians,
  });

  final double startRadians, endRadians;

  @override
  Path getClip(Size size) {
    assert(size.width == size.height);
    assert(endRadians > startRadians);
    return _makeSlicePath(
      radius: size.width / 2,
      startRadians: startRadians,
      endRadians: endRadians,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _SliceBorderPainter extends CustomPainter {
  _SliceBorderPainter({
    required this.startRadians,
    required this.endRadians,
    required this.color,
  });

  final double startRadians, endRadians;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    assert(size.width == size.height);
    assert(endRadians > startRadians);

    canvas.drawPath(
      _makeSlicePath(
        radius: size.width / 2,
        startRadians: startRadians,
        endRadians: endRadians,
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

extension on List<Activity> {
  int get totalWeight => fold(0, (w, a) => w + a.weight);
}

Path _makeSlicePath({
  required double radius,
  required double startRadians,
  required double endRadians,
}) {
  return Path()
    // Move to the east edge of the circle.
    ..moveTo(
      radius * 2 + (radius * cos(startRadians)),
      radius + (radius * sin(startRadians)),
    )
    // Arc from r to r' assuming [size] is the entire rectangle to arc in.
    // Note that the "end radians" is a delta, not an absolute value, hence
    // why this code subtracts start from end.
    // Also note that forceMoveTo is true to clean up the arc's final line.
    ..arcTo(
      Rect.fromLTWH(0, 0, radius * 2, radius * 2),
      startRadians,
      endRadians - startRadians,
      true,
    )
    // Finish up the pie slice by moving back to the center.
    ..lineTo(
      radius,
      radius,
    )
    // Always close your paths :)
    ..close();
}
