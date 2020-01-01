import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

class CirclesDraw extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white70;
    paint.style = PaintingStyle.stroke;
    canvas.drawCircle(
        Offset(0, 0),
        105,
        paint
    );
    canvas.drawCircle(
        Offset(0, 0),
        65,
        paint
    );
    canvas.drawCircle(
        Offset(0, 0),
        30,
        paint
    );
    paint.color = Colors.orange;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(0, 0),
        10,
        paint
    );
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BackgroundCircles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: CirclesDraw(),
      ),
    );
  }
}