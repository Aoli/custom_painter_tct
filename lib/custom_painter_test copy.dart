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
    final borderWidth = 5.0;
    final borderGap = 2.0;

    // Border paint (draw this first)
    final borderPaint = Paint()
      ..color = Colors.red.shade900 // Darker red for border
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Draw outer border circle
    canvas.drawCircle(
        center,
        radius -
            borderGap -
            (borderWidth / 2), // Adjust radius for gap and border width
        borderPaint);

    // Metallic red gradient for base circle
    final metalRedGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      colors: [
        Colors.red.shade300, // Highlight
        Colors.red.shade400, // Light
        Colors.red.shade700, // Middle
        Colors.red.shade900, // Shadow
        Colors.red.shade700, // Edge
      ],
    );

    final circlePaint = Paint()
      ..shader = metalRedGradient
          .createShader(Rect.fromCircle(center: center, radius: radius))
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
      ..strokeWidth = 4; // Reduced from 6

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3; // Reduced from 5

    final mainStripPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    const numberOfStrips = 360 ~/ 30; // Every 30 degrees
    const curveOffset = 0.8; // Increased from 0.6 for more curve
    const angleOffset = 0.5; // Increased from 0.3 for more aggressive curve
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

    // Add center bolt
    final boltPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: 20, // Wider bolt
        height: 12, // Flatter bolt
      ),
      boltPaint,
    );
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

    // Metallic blue gradient for base circle
    final metalBlueGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      colors: [
        Colors.blue.shade300, // Highlight
        Colors.blue.shade400, // Light
        Colors.blue.shade700, // Middle
        Colors.blue.shade900, // Shadow
        Colors.blue.shade700, // Edge
      ],
    );

    final circlePaint = Paint()
      ..shader = metalBlueGradient
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, circlePaint);

    // Center bolt
    final boltPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    // Draw wider, flatter bolt
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: 20, // Increased width
        height: 12, // Reduced height for flatter appearance
      ),
      boltPaint,
    );

    // Draw blades with 3D effect (30 degrees offset from red blades)
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4; // Reduced from 6

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.5) // Increased opacity
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3; // Reduced from 5

    // Updated metallic strip paint
    final metalStripGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      colors: [
        Colors.grey.shade300, // Lighter highlight
        Colors.grey.shade400,
        Colors.grey.shade600, // Middle tone
        Colors.grey.shade700,
        Colors.grey.shade500, // Edge reflection
      ],
    );

    final mainStripPaint = Paint()
      ..shader = metalStripGradient
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3; // Reduced from 5

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

// Update PipePainter class:
class PipePainter extends CustomPainter {
  final double pipeLength;
  final double circleRadius;
  final bool isLeftPipe; // New parameter

  PipePainter({
    required this.pipeLength,
    required this.circleRadius,
    this.isLeftPipe = false, // Default to right pipe
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final pipeWidth = circleRadius * 0.4;
    final bandWidth = pipeWidth * 0.4;

    // Adjust position based on direction
    final pipeRect = Rect.fromCenter(
      center: Offset(
          center.dx + (isLeftPipe ? -pipeLength / 2 : pipeLength / 2),
          center.dy +
              (isLeftPipe
                  ? (size.height / 2) - (pipeWidth / 2)
                  : -(size.height / 2) + (pipeWidth / 2))),
      width: pipeLength,
      height: pipeWidth,
    );

    // Adjust band position based on direction
    final bandRect = Rect.fromCenter(
      center: Offset(
          center.dx +
              (isLeftPipe
                  ? -pipeLength + (bandWidth / 2)
                  : pipeLength - (bandWidth / 2)),
          center.dy +
              (isLeftPipe
                  ? (size.height / 2) - (pipeWidth / 2)
                  : -(size.height / 2) + (pipeWidth / 2))),
      width: bandWidth,
      height: pipeWidth * 1.15,
    );

    // Gradients with different colors based on pipe position
    final pipeGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.0, 0.5, 1.0],
      colors: isLeftPipe
          ? [
              Colors.grey.shade300, // Lighter gray top
              Colors.grey.shade400, // Gray middle
              Colors.grey.shade300, // Lighter gray bottom
            ]
          : [
              Colors.red.shade200, // Lighter pale red top
              Colors.red.shade300, // Pale red middle
              Colors.red.shade200, // Lighter pale red bottom
            ],
    );

    // Modified band gradient for more belt-like appearance
    final bandGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
      colors: isLeftPipe
          ? [
              Colors.grey.shade300, // Light edge
              Colors.grey.shade400, // Light shadow
              Colors.grey.shade500, // Middle
              Colors.grey.shade400, // Light shadow
              Colors.grey.shade300, // Light edge
            ]
          : [
              Colors.red.shade200, // Pale edge
              Colors.red.shade300, // Pale shadow
              Colors.red.shade400, // Pale middle
              Colors.red.shade300, // Pale shadow
              Colors.red.shade200, // Pale edge
            ],
    );

    // Paints
    final pipePaint = Paint()
      ..shader = pipeGradient.createShader(pipeRect)
      ..style = PaintingStyle.fill;

    final bandPaint = Paint()
      ..shader = bandGradient.createShader(bandRect)
      ..style = PaintingStyle.fill;

    // Update shadow opacity for left pipe
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Create shapes with different radiuses
    final pipeRRect = RRect.fromRectAndRadius(
      pipeRect,
      Radius.circular(pipeWidth /
          8), // Changed from pipeWidth/2 to match band's corner radius
    );

    // Create band with sharper corners
    final bandRRect = RRect.fromRectAndRadius(
      bandRect,
      Radius.circular(pipeWidth / 8), // Much less rounded for band
    );

    // Draw shadow
    canvas.drawRRect(
      pipeRRect.shift(const Offset(2, 2)),
      shadowPaint,
    );
    canvas.drawRRect(
      bandRRect.shift(const Offset(2, 2)),
      shadowPaint,
    );

    // Draw main pipe
    canvas.drawRRect(pipeRRect, pipePaint);

    // Draw mounting band
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
  double _blueDiameter = 230.0;
  static const double _holeDiameter = 100.0;

  late AnimationController
      _speedController; // Single controller for both circles
  bool _isSpinning = false;
  Duration _spinDuration = const Duration(seconds: 15); // Total spin time

  // Add speed multiplier
  double _speedMultiplier = 1.0;

  @override
  void initState() {
    super.initState();
    _speedController = AnimationController(
      vsync: this,
      duration: _spinDuration,
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
        _speedController.reset();
        _speedController
            .animateTo(
          1.0,
          duration: Duration(
              milliseconds:
                  (_spinDuration.inMilliseconds / _speedMultiplier).round()),
          curve: Curves.easeOut,
        )
            .then((_) {
          setState(() {
            _isSpinning = false;
          });
        });
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
            // Add left pipe (drawn first, so it appears below other elements)
            CustomPaint(
              size: Size(max(_redDiameter, _blueDiameter),
                  max(_redDiameter, _blueDiameter)),
              painter: PipePainter(
                pipeLength: (_redDiameter / 2) * 1.2,
                circleRadius: _redDiameter / 2,
                isLeftPipe: true, // New parameter to indicate left pipe
              ),
            ),
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
            // Existing right pipe
            CustomPaint(
              size: Size(max(_redDiameter, _blueDiameter),
                  max(_redDiameter, _blueDiameter)),
              painter: PipePainter(
                pipeLength: (_redDiameter / 2) * 1.2,
                circleRadius: _redDiameter / 2,
                isLeftPipe: false, // Default right pipe
              ),
            ),
            // Add center bolt on top
            CustomPaint(
              size: Size(25, 25), // Make width and height equal for round bolt
              painter: BoltPainter(),
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
              // Keep existing circle size controls
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
              // Duration control
              Row(
                children: [
                  const Text('Duration: '),
                  Expanded(
                    child: Slider(
                      value: _spinDuration.inMilliseconds.toDouble(),
                      min: 5000,
                      max: 20000,
                      onChanged: (value) {
                        setState(() {
                          _spinDuration = Duration(milliseconds: value.round());
                          if (_isSpinning) {
                            _toggleSpin();
                          }
                        });
                      },
                    ),
                  ),
                  Text(
                      '${(_spinDuration.inMilliseconds / 1000).toStringAsFixed(1)}s'),
                ],
              ),
              // Speed multiplier control
              Row(
                children: [
                  const Text('Speed: '),
                  Expanded(
                    child: Slider(
                      value: _speedMultiplier,
                      min: 0.5,
                      max: 2.0,
                      onChanged: (value) {
                        setState(() {
                          _speedMultiplier = value;
                          if (_isSpinning) {
                            _toggleSpin();
                          }
                        });
                      },
                    ),
                  ),
                  Text('${_speedMultiplier.toStringAsFixed(1)}x'),
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

// Add new BoltPainter class:
class BoltPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 12.5;

    // Metallic gradient for bolt
    final metalGradient = RadialGradient(
      center: const Alignment(-0.3, -0.3), // Offset for light source
      radius: 0.9,
      stops: const [0.0, 0.3, 0.6, 0.9, 1.0],
      colors: [
        Colors.grey.shade400, // Highlight
        Colors.grey.shade500,
        Colors.grey.shade600,
        Colors.grey.shade700,
        Colors.grey.shade800, // Edge shadow
      ],
    );

    final boltPaint = Paint()
      ..shader = metalGradient
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    // Draw metallic bolt
    canvas.drawCircle(
      center,
      radius,
      boltPaint,
    );

    // Add subtle highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - 3, center.dy - 3),
      radius * 0.3,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
