import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:osrs_rng/features/rng_simulator/rng_simulator.dart';

class RngSimulatorPage extends StatefulWidget {
  const RngSimulatorPage({super.key});

  @override
  State<RngSimulatorPage> createState() => _RngSimulatorPageState();
}

class _RngSimulatorPageState extends State<RngSimulatorPage> {
  final _fraction = TextEditingController();
  var _percentage = 0.0;

  @override
  void initState() {
    super.initState();
    _fraction.addListener(
      () {
        setState(() {
          final ints = _fraction.text.split('/').map(int.tryParse);
          if (ints.length == 2 && ints.every((i) => i != null)) {
            _percentage = (ints.first! / ints.last!).abs();
          } else {
            _percentage = 0.0;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _fraction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Curious how drop rates work?',
              ),
              const SizedBox(height: 4),
              const Text(
                'Insert a drop rate to simulate an attempt at getting it.',
              ),
              const SizedBox(height: 4),
              const Text(
                'The left-most line(s) is a successful drop, while the others are misses.',
              ),
              TextField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                autocorrect: false,
                decoration: InputDecoration(
                  label: Text('X/Y ($_percentage%)'),
                ),
                controller: _fraction,
              ),
              const SizedBox(height: 12),
              _Simulator(
                numerator: _numerator,
                denominator: _denominator,
              ),
            ],
          ),
        ),
      ),
    );
  }

  int? get _numerator {
    final paths = _fraction.text.split('/');
    if (paths.length != 2) return null;
    final first = int.tryParse(paths.first);
    if (first == null || first <= 0) return null;
    return first;
  }

  int? get _denominator {
    final paths = _fraction.text.split('/');
    if (paths.length != 2) return null;
    final last = int.tryParse(paths.last);
    if (last == null || last <= 0) return null;
    return last;
  }
}

class _Simulator extends StatefulWidget {
  const _Simulator({
    required this.numerator,
    required this.denominator,
  });

  final int? numerator, denominator;

  @override
  State<_Simulator> createState() => _SimulatorState();
}

class _SimulatorState extends State<_Simulator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  var _depths = <int>[];

  int get _attempts => _depths.fold(0, (t, v) => t += v);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: 1.seconds,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant _Simulator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller
      ..reset()
      ..forward();

    final n = widget.numerator, d = widget.denominator;
    if (n != null && d != null && n < d && n > 0) {
      _depths = simulate(
        numerator: n,
        denominator: d,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _PaintDripSimulation(
                    progress: _controller.value,
                    depths: _depths,
                    primaryLength: widget.numerator ?? 0,
                    maxDepth: 10,
                  ),
                );
              },
            ),
          ),
          if (!_attempts.isNaN &&
              widget.numerator != null &&
              widget.denominator != null)
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  'You took $_attempts attempts at a ${widget.numerator}/${widget.denominator} drop.',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PaintDripSimulation extends CustomPainter {
  const _PaintDripSimulation({
    required this.progress,
    required this.depths,
    required this.primaryLength,
    required this.maxDepth,
  }) : assert(0 <= progress && progress <= 1);

  final double progress;
  final List<int> depths;
  final int primaryLength;
  final int maxDepth;

  @override
  void paint(Canvas canvas, Size size) {
    final primaryPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 1;
    final secondaryPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1;

    final dripWidth = size.width / depths.length;
    final dripSegmentLength = size.height / maxDepth;
    final max = (progress * depths.length).floor();
    final maxRemainder = (progress * depths.length) - max;

    for (var i = 0; i < max; i++) {
      final depth = depths[i];
      final x = i * dripWidth + dripWidth / 2;
      var y = depth * dripSegmentLength;
      if (i == max - 1) {
        y *= maxRemainder;
      }
      if (y > size.height) continue; // don't go out of bounds
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, y),
        i < primaryLength ? primaryPaint : secondaryPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
