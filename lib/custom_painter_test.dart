import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin, max;

class HollowCirclePainter extends CustomPainter {
  final double diameter;
  final double holeDiameter;

  HollowCirclePainter({required this.diameter, required this.holeDiameter});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = diameter / 2;
    final holeRadius = holeDiameter / 2;

    // Base red circle with hole
    final circlePaint = Paint()
      ..color = const Color(0xFFFF0000)
      ..style = PaintingStyle.fill;

    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..addOval(Rect.fromCircle(center: center, radius: holeRadius))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(circlePath, circlePaint);

    // Draw wavy strips with 3D effect
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final mainStripPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    const numberOfStrips = 360 ~/ 30; // Every 30 degrees
    const curveOffset = 0.6; // Reduced from 0.8 for flatter curve
    const angleOffset = 0.3; // Reduced from 0.6 for less aggressive curve
    const shadowOffset = 3.0;

    for (var i = 0; i < numberOfStrips; i++) {
      final angle = (i * 30) * pi / 180;
      final path = Path();
      final shadowPath = Path();
      final highlightPath = Path();

      // Start point on outer circle
      final startX = center.dx + radius * cos(angle);
      final startY = center.dy + radius * sin(angle);

      // End point on inner circle
      final endX = center.dx + holeRadius * cos(angle);
      final endY = center.dy + holeRadius * sin(angle);

      // Control point for flatter C-shaped curve
      final controlX =
          center.dx + radius * curveOffset * cos(angle - angleOffset);
      final controlY =
          center.dy + radius * curveOffset * sin(angle - angleOffset);

      // Create main C-shaped path
      path.moveTo(startX, startY);
      path.quadraticBezierTo(controlX, controlY, endX, endY);

      // Create shadow path with offset
      shadowPath.moveTo(startX + shadowOffset, startY + shadowOffset);
      shadowPath.quadraticBezierTo(controlX + shadowOffset,
          controlY + shadowOffset, endX + shadowOffset, endY + shadowOffset);

      // Create highlight path with negative offset
      highlightPath.moveTo(startX - shadowOffset, startY - shadowOffset);
      highlightPath.quadraticBezierTo(controlX - shadowOffset,
          controlY - shadowOffset, endX - shadowOffset, endY - shadowOffset);

      // Draw in order: shadow, main strip, highlight
      canvas.drawPath(shadowPath, shadowPaint);
      canvas.drawPath(path, mainStripPaint);
      canvas.drawPath(highlightPath, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(HollowCirclePainter oldDelegate) {
    return oldDelegate.diameter != diameter ||
        oldDelegate.holeDiameter != holeDiameter;
  }
}

class BlueBladePainter extends CustomPainter {
  final double diameter;

  BlueBladePainter({required this.diameter});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = diameter / 2;

    // Base blue circle
    final circlePaint = Paint()
      ..color = Colors.blue.withOpacity(1.0)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, circlePaint);

    // Center bolt
    final boltPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8, boltPaint);

    // Draw blades with 3D effect (30 degrees offset from red blades)
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final mainStripPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    const numberOfStrips = 360 ~/ 30;
    const curveOffset = 0.8; // Increased from 0.6 for more curve
    const angleOffset = 0.5; // Increased from 0.3 for more aggressive curve
    const shadowOffset = 3.0;

    for (var i = 0; i < numberOfStrips; i++) {
      final angle = ((i * 30) + 15) * pi / 180; // Changed to 15 degrees offset
      final path = Path();
      final shadowPath = Path();
      final highlightPath = Path();

      final startX = center.dx + radius * cos(angle);
      final startY = center.dy + radius * sin(angle);

      final endX = center.dx + 8 * cos(angle); // End at bolt
      final endY = center.dy + 8 * sin(angle);

      final controlX =
          center.dx + radius * curveOffset * cos(angle - angleOffset);
      final controlY =
          center.dy + radius * curveOffset * sin(angle - angleOffset);

      path.moveTo(startX, startY);
      path.quadraticBezierTo(controlX, controlY, endX, endY);

      shadowPath.moveTo(startX + shadowOffset, startY + shadowOffset);
      shadowPath.quadraticBezierTo(controlX + shadowOffset,
          controlY + shadowOffset, endX + shadowOffset, endY + shadowOffset);

      highlightPath.moveTo(startX - shadowOffset, startY - shadowOffset);
      highlightPath.quadraticBezierTo(controlX - shadowOffset,
          controlY - shadowOffset, endX - shadowOffset, endY - shadowOffset);

      canvas.drawPath(shadowPath, shadowPaint);
      canvas.drawPath(path, mainStripPaint);
      canvas.drawPath(highlightPath, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(BlueBladePainter oldDelegate) {
    return oldDelegate.diameter != diameter;
  }
}

class PipePainter extends CustomPainter {
  final double pipeLength;
  final double circleRadius;

  PipePainter({
    required this.pipeLength,
    required this.circleRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final pipeWidth = circleRadius * 0.4;
    final bandWidth = pipeWidth * 0.4; // Width of the mounting band

    // Main pipe rectangle (full length, no shrinking)
    final pipeRect = Rect.fromCenter(
      center: Offset(center.dx + (pipeLength / 2),
          center.dy - (size.height / 2) + (pipeWidth / 2)),
      width: pipeLength, // No reduction for band
      height: pipeWidth,
    );

    // Band rectangle at the end (protrudes from pipe)
    final bandRect = Rect.fromCenter(
      center: Offset(center.dx + pipeLength - (bandWidth / 2),
          center.dy - (size.height / 2) + (pipeWidth / 2)),
      width: bandWidth,
      height: pipeWidth * 1.15, // Slightly larger than pipe
    );

    // Gradients
    final pipeGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.0, 0.5, 1.0],
      colors: [
        Colors.grey.shade400, // Lighter top
        Colors.grey.shade600, // Darker middle
        Colors.grey.shade400, // Lighter bottom
      ],
    );

    // Modified band gradient for more belt-like appearance
    final bandGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
      colors: [
        Colors.grey.shade400, // Edge
        Colors.grey.shade500, // Shadow
        Colors.grey.shade600, // Middle
        Colors.grey.shade500, // Shadow
        Colors.grey.shade400, // Edge
      ],
    );

    // Paints
    final pipePaint = Paint()
      ..shader = pipeGradient.createShader(pipeRect)
      ..style = PaintingStyle.fill;

    final bandPaint = Paint()
      ..shader = bandGradient.createShader(bandRect)
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Create custom pipe path
    final pipePath = Path();
    final radius = pipeWidth / 2; // Use same radius for all corners

    // Start from top-left
    pipePath.moveTo(center.dx, center.dy - (size.height / 2));

    // Add top-left corner with full radius
    pipePath.quadraticBezierTo(
        center.dx,
        center.dy - (size.height / 2) + (pipeWidth / 2),
        center.dx + radius,
        center.dy - (size.height / 2) + (pipeWidth / 2));

    // Draw top line
    pipePath.lineTo(center.dx + pipeLength - radius,
        center.dy - (size.height / 2) + (pipeWidth / 2));

    // Add right end rounded corners
    pipePath.arcToPoint(
        Offset(
            center.dx + pipeLength, center.dy - (size.height / 2) + pipeWidth),
        radius: Radius.circular(radius),
        clockwise: true);

    // Draw bottom line
    pipePath.lineTo(
        center.dx + radius, center.dy - (size.height / 2) + pipeWidth);

    // Add bottom-left corner
    pipePath.quadraticBezierTo(
        center.dx,
        center.dy - (size.height / 2) + pipeWidth,
        center.dx,
        center.dy - (size.height / 2) + (pipeWidth / 2));

    pipePath.close();

    // Update shadow drawing
    canvas.drawPath(pipePath.shift(const Offset(2, 2)), shadowPaint);

    // Draw main pipe
    canvas.drawPath(pipePath, pipePaint);

    // Define bandRRect
    final bandRRect = RRect.fromRectAndRadius(
      bandRect,
      Radius.circular(pipeWidth * 0.2), // Adjust the radius as needed
    );

    // Keep existing band drawing code
    canvas.drawRRect(bandRRect, bandPaint);
  }

  @override
  bool shouldRepaint(PipePainter oldDelegate) {
    return oldDelegate.pipeLength != pipeLength ||
        oldDelegate.circleRadius != circleRadius;
  }
}

class CircleControlWidget extends StatefulWidget {
  const CircleControlWidget({super.key});

  @override
  State<CircleControlWidget> createState() => _CircleControlWidgetState();
}

class _CircleControlWidgetState extends State<CircleControlWidget>
    with TickerProviderStateMixin {
  double _redDiameter = 300.0;
  double _blueDiameter = 280.0;
  static const double _holeDiameter = 100.0;

  late AnimationController
      _speedController; // Single controller for both circles
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _speedController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _speedController.dispose();
    super.dispose();
  }

  void _toggleSpin() {
    setState(() {
      _isSpinning = !_isSpinning;
      if (_isSpinning) {
        _speedController.repeat();
      } else {
        _speedController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Existing red circle
            AnimatedBuilder(
              animation: _speedController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: -_speedController.value * 2 * pi,
                  child: HollowCircleWidget(
                    diameter: _redDiameter,
                    holeDiameter: _holeDiameter,
                  ),
                );
              },
            ),
            // Existing blue circle
            AnimatedBuilder(
              animation: _speedController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: -_speedController.value * 2 * pi + (15 * pi / 180),
                  child: CustomPaint(
                    size: Size(_blueDiameter, _blueDiameter),
                    painter: BlueBladePainter(diameter: _blueDiameter),
                  ),
                );
              },
            ),
            // Add new pipe layer
            CustomPaint(
              size: Size(max(_redDiameter, _blueDiameter),
                  max(_redDiameter, _blueDiameter)),
              painter: PipePainter(
                pipeLength: (_redDiameter / 2) * 1.2, // radius + 20%
                circleRadius: _redDiameter / 2, // Pass the red circle's radius
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Add spin control button
        ElevatedButton(
          onPressed: _toggleSpin,
          child: Text(_isSpinning ? 'Stop' : 'Spin'),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Red Circle: '),
                  Expanded(
                    child: Slider(
                      value: _redDiameter,
                      min: 150.0,
                      max: 400.0,
                      onChanged: (value) {
                        setState(() {
                          _redDiameter = value;
                        });
                      },
                    ),
                  ),
                  Text('${_redDiameter.round()}'),
                ],
              ),
              Row(
                children: [
                  const Text('Blue Circle: '),
                  Expanded(
                    child: Slider(
                      value: _blueDiameter,
                      min: 100.0,
                      max: 350.0,
                      onChanged: (value) {
                        setState(() {
                          _blueDiameter = value;
                        });
                      },
                    ),
                  ),
                  Text('${_blueDiameter.round()}'),
                ],
              ),
              Row(
                children: [
                  const Text('Speed: '),
                  Expanded(
                    child: Slider(
                      value:
                          _speedController.duration!.inMilliseconds.toDouble(),
                      min: 1000, // Minimum 1 second
                      max: 10000, // Maximum 10 seconds
                      onChanged: (value) {
                        setState(() {
                          _speedController.duration =
                              Duration(milliseconds: value.round());
                          if (_isSpinning) {
                            _speedController.repeat();
                          }
                        });
                      },
                    ),
                  ),
                  Text(
                      '${(_speedController.duration!.inMilliseconds / 1000).toStringAsFixed(1)}s'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HollowCircleWidget extends StatelessWidget {
  final double diameter;
  final double holeDiameter;

  const HollowCircleWidget(
      {super.key, required this.diameter, required this.holeDiameter});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter:
          HollowCirclePainter(diameter: diameter, holeDiameter: holeDiameter),
      size: Size(diameter, diameter), // Ensure the widget is square
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircleControlWidget(),
    );
  }
}
