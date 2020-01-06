/*
*  main clock class
*  created by achintya kattemalavadi
*  january 3, 2019
*/

import 'dart:async';

import 'package:analog_clock/background_circles.dart';
import 'package:analog_clock/weather_icon.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'drawn_hand.dart';
import 'background_circles.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A basic analog clock.
///
/// You can do better than this!
class AchintyaClock extends StatefulWidget {
  const AchintyaClock(this.model);

  final ClockModel model;

  @override
  _AchintyaClockState createState() => _AchintyaClockState();
}

class _AchintyaClockState extends State<AchintyaClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureLow = '';
  var _temperatureHigh = '';
  var _condition = '';
  var _location = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AchintyaClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureLow = '${widget.model.low}';
      _temperatureHigh = '${widget.model.highString}';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per millisecond. Make sure to do it at the beginning of each
      // new millisecond, so that the clock is accurate.
      _timer = Timer(
        Duration(milliseconds: 1) - Duration(microseconds: _now.microsecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Colors.deepPurple,
            // Minute hand.
            highlightColor: Colors.teal,
            // Second hand.
            accentColor: Colors.blue,
            backgroundColor: Colors.white,
          )
        : Theme.of(context).copyWith(
            primaryColor: Colors.purpleAccent,
            highlightColor: Colors.tealAccent,
            accentColor: Colors.lightBlueAccent,
            backgroundColor: Colors.black,
          );

    final time = DateFormat.Hms().format(DateTime.now());
    final locationInfo = DefaultTextStyle(
      style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat.yMMMMEEEEd().format(_now),
          ),
        ],
      ),
    );
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 11,
        color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WeatherIcon(condition: _condition),
          Text(
            _temperature,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text('Low: ' + _temperatureLow + ', High: ' + _temperatureHigh),
          Text(_location + ", Earth"),
        ],
      ),
    );

    final planetColorsDay = [
      Colors.teal, Colors.blue, Colors.deepPurple, Colors.red,
    ];

    final planetColorsNight = [
      Colors.redAccent, Colors.purpleAccent, Colors.lightBlueAccent, Colors.tealAccent,
    ];

    /*
    TODO: clean and comment code
     rewrite stuff that isn't yours
     add licenses
     rename project based on submission guidelines
     add am/pm stuff
     add containers to wrap text if too large/make more accessible
    */

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        color: customTheme.backgroundColor,
        child: Stack(
          children: [
            // Example of a hand drawn with [CustomPainter].
            BackgroundCircles(
              orbitsColor: Theme.of(context).brightness == Brightness.light ? Colors.deepPurple : Colors.amber,
            ),
            DrawnHand(
              colors: Theme.of(context).brightness == Brightness.light ? planetColorsDay : planetColorsNight,
              radius: 8,
              distFromCenter: 96,
              angleRadians: _now.second * radiansPerTick +
                  (_now.millisecond / 1000) * radiansPerTick,
            ),
            DrawnHand(
              colors: Theme.of(context).brightness == Brightness.light ? planetColorsDay : planetColorsNight,
              radius: 20,
              distFromCenter: 64,
              angleRadians: _now.minute * radiansPerTick +
                  (_now.second / 60) * radiansPerTick,
              showText: _now.minute.toString().padLeft(2, '0'),
              textColor: customTheme.backgroundColor,
            ),
            DrawnHand(
              colors: Theme.of(context).brightness == Brightness.light ? planetColorsDay : planetColorsNight,
              radius: 20,
              distFromCenter: 20,
              angleRadians: _now.hour * radiansPerHour +
                  (_now.minute / 60) * radiansPerHour,
              showText: DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_now).padLeft(2, '0'),
              textColor: customTheme.backgroundColor,
            ),
            Positioned(
              right: 0.0,
              top: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: locationInfo,
              ),
            ),
            Positioned(
              right: 0.0,
              bottom: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: weatherInfo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
