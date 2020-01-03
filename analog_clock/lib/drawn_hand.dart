// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class DrawnHand extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  DrawnHand({
    @required List<Color> colors,
    @required this.radius,
    @required double distFromCenter,
    @required double angleRadians,
    this.showText,
    this.textColor,
  })  : assert(colors != null),
        assert(radius != null),
        assert(distFromCenter != null),
        assert(angleRadians != null),
        super(
          colors: colors,
          distFromCenter: distFromCenter,
          angleRadians: angleRadians,
        );

  /// How thick the hand should be drawn, in logical pixels.
  final double radius;
  String showText = "";
  Color textColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
            distFromCenter: distFromCenter,
            circleRadius: radius,
            angleRadians: angleRadians,
            colors: colors,
            showText: showText,
            textColor: textColor,
          ),
        ),
      ),
    );
  }
}

/// [CustomPainter] that draws a clock hand.
class _HandPainter extends CustomPainter {
  _HandPainter({
    @required this.distFromCenter,
    @required this.circleRadius,
    @required this.angleRadians,
    @required this.colors,
    this.showText,
    this.textColor,
  })  : assert(distFromCenter != null),
        assert(circleRadius != null),
        assert(angleRadians != null),
        assert(colors != null),
        assert(distFromCenter >= 0.0);

  double distFromCenter;
  double circleRadius;
  double angleRadians;
  List<Color> colors;
  Color textColor;
  String showText = "";

  @override
  void paint(Canvas canvas, Size size) {
    // We want to start at the top, not at the x-axis, so add pi/2.
    final angle = angleRadians - math.pi / 2.0;
    final center = (Offset.zero & size).center.translate(-80.0, 0.0);
    final position = center + Offset(math.cos(angle), math.sin(angle)) * distFromCenter;
    final Shader radialGradient = RadialGradient(
      colors: colors,
    ).createShader(Rect.fromCenter(center: center, width: 200.0, height: 200.0));
    final circlePaint = Paint()
      ..shader = radialGradient
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, circleRadius, circlePaint);
    if (showText != "") {
      final textStyle = TextStyle(
        color: this.textColor,
        fontSize: 26,
        fontFamily: 'monospace',
        fontWeight: FontWeight.w900,
      );
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
      textPainter.paint(canvas, position.translate(-15, -15));
    }
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.distFromCenter != distFromCenter ||
        oldDelegate.circleRadius != circleRadius ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.colors != colors;
  }
}
