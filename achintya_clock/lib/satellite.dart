/*
*  satellite class
*  adapted from sample analog_clock drawn_hand
*  created by achintya kattemalavadi
*  january 2019
*/

// imports
import 'package:achintya_clock/constants.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

// painter for satellites
class _SatellitePainter extends CustomPainter {
  // class variables
  final double distFromCenter;
  final double circleRadius;
  final double angleRadians;
  final List<Color> colors;
  String showText = "";
  TextStyle textStyle = TextStyle();
  Offset textOffset = Offset(0, 0);

  // constructor
  _SatellitePainter({
    @required this.distFromCenter,
    @required this.circleRadius,
    @required this.angleRadians,
    @required this.colors,
    this.showText,
    this.textStyle,
    this.textOffset,
  })  : assert(distFromCenter != null),
        assert(circleRadius != null),
        assert(angleRadians != null),
        assert(colors != null),
        assert(distFromCenter >= 0.0);

  // paint method
  @override
  void paint(Canvas canvas, Size size) {
    // angle offset to start on positive y-axis
    final angle = angleRadians - math.pi / 2.0;

    // center, offset to left by 80
    final center = (Offset.zero & size).center.translate(orbitsdx, 0.0);

    // center of drawn satellite
    final position =
        center + Offset(math.cos(angle), math.sin(angle)) * distFromCenter;

    // creating the gradient shader for the painter
    final Shader radialGradient = RadialGradient(
      colors: colors,
    ).createShader(
        Rect.fromCenter(center: center, width: 400.0, height: 200.0));

    // paint for the satellite
    final circlePaint = Paint()
      ..shader = radialGradient
      ..style = PaintingStyle.fill;

    // drawing the satellite
    canvas.drawCircle(position, circleRadius, circlePaint);

    // if text needs to be drawn, draw it
    if (showText != null && showText != "" && textOffset != null) {
      final textSpan = TextSpan(
        text: showText,
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      // center the text over the satellite
      textPainter.paint(
          canvas,
          position.translate(
              textOffset.dx, textOffset.dy)); // TODO: pass in offset
    }
  }

  @override
  bool shouldRepaint(_SatellitePainter oldDelegate) {
    return oldDelegate.distFromCenter != distFromCenter ||
        oldDelegate.circleRadius != circleRadius ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.colors != colors ||
        oldDelegate.showText != showText ||
        oldDelegate.textStyle != textStyle ||
        oldDelegate.textOffset != textOffset;
  }
}

// class declaration
class Satellite extends StatelessWidget {
  // class variables
  final List<Color> colors;
  final double distFromCenter;
  final double angleRadians;
  final double radius;
  final String showText;
  final TextStyle textStyle;
  final Offset textOffset;

  // constructor
  Satellite({
    @required this.colors,
    @required this.radius,
    @required this.distFromCenter,
    @required this.angleRadians,
    String showText,
    TextStyle textStyle,
    Offset textOffset,
  })  : assert(colors != null),
        assert(radius != null),
        assert(distFromCenter != null),
        assert(angleRadians != null),
        this.showText = showText,
        this.textStyle = textStyle,
        this.textOffset = textOffset;

  // build method
  @override
  Widget build(BuildContext context) {
    // centering and expanding to draw numbers without wrapping
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _SatellitePainter(
            distFromCenter: distFromCenter,
            circleRadius: radius,
            angleRadians: angleRadians,
            colors: colors,
            showText: showText,
            textStyle: textStyle,
            textOffset: textOffset,
          ),
        ),
      ),
    );
  }
}
