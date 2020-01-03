/*
*  orbits for clock
*  created by achintya kattemalavadi
*  january 3, 2019
*/

// imports
import 'dart:ui';
import 'package:flutter/material.dart';

// drawing class header
class CirclesDraw extends CustomPainter {

  // constants
  final double orbitsOffset = -80.0;
  final double orbitWidth = 1.2;
  final double hourRadius = 96.0;
  final double minuteRadius = 64.0;
  final double secondRadius = 20.0;

  // color for orbits
  final Color orbitsColor;

  // constructor
  CirclesDraw({
    @required this.orbitsColor,
  }) : assert(orbitsColor != null);

  // paint method
  @override
  void paint(Canvas canvas, Size size) {
    // offset slightly off center
    final center = (Offset.zero & size).center.translate(orbitsOffset, 0.0);
    // painter
    var paint = Paint()
      ..color = this.orbitsColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = orbitWidth;
    // draw the orbits
    canvas.drawCircle(
        center,
        hourRadius,
        paint
    );
    canvas.drawCircle(
        center,
        minuteRadius,
        paint
    );
    canvas.drawCircle(
        center,
        secondRadius,
        paint
    );
  }
  // repaint method
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// class header
class BackgroundCircles extends StatelessWidget {

  // color for orbits
  final Color orbitsColor;

  // constructor
  BackgroundCircles({
    @required this.orbitsColor,
  }) : assert(orbitsColor != null);

  // build method
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: CirclesDraw(
          orbitsColor: this.orbitsColor,
        ),
      ),
    );
  }
}