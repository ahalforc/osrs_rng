import 'dart:math';

import 'package:flutter/material.dart';
import 'package:osrs_rng/features/activity_randomizer/activity_randomizer.dart';

class ActivitySlice extends StatelessWidget {
  const ActivitySlice({
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
        color: Theme.of(context).colorScheme.secondaryContainer,
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
        ..strokeWidth = 10
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
