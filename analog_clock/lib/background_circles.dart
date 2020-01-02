import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

class CirclesDraw extends CustomPainter {
  final Color orbitsColor;
  final List<Color> centerColors;
  CirclesDraw({
    @required this.orbitsColor,
    @required this.centerColors,
  }) : assert(orbitsColor != null),
    assert(centerColors != null);
  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center.translate(-80.0, 0.0);
    final Shader linearGradient = LinearGradient(
      colors: centerColors,
    ).createShader(Rect.fromCenter(center: center, width: 10.0, height: 10.0));
    var paint = Paint()
      ..shader = linearGradient
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        center,
        10,
        paint
    );
    paint = Paint()
      ..color = this.orbitsColor
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
        center,
        105,
        paint
    );
    canvas.drawCircle(
        center,
        80,
        paint
    );
    canvas.drawCircle(
        center,
        35,
        paint
    );
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BackgroundCircles extends StatelessWidget {
  final Color orbitsColor;
  final List<Color> centerColors;
  BackgroundCircles({
    @required this.orbitsColor,
    @required this.centerColors,
  }) : assert(orbitsColor != null),
    assert(centerColors != null);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: CirclesDraw(
          orbitsColor: this.orbitsColor,
          centerColors: this.centerColors,
        ),
      ),
    );
  }
}