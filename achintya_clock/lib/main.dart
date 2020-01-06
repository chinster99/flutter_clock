/*
*  main for clock
*  adapted from sample analog_clock main
*  created by achintya kattemalavadi
*  january 3, 2019
*/

// includes
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';

import 'achintya_clock.dart';

// main method
void main() {

  // target platform override for macos
  if (!kIsWeb && Platform.isMacOS)
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  // creating the clock customizer
  runApp(ClockCustomizer((ClockModel cm) => AchintyaClock(cm)));
}
