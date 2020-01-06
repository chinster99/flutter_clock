/*
*  main clock class
*  created by achintya kattemalavadi
*  january 3, 2019
*/

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'dart:async';

import 'package:achintya_clock/background_circles.dart';
import 'package:achintya_clock/weather_icon.dart';
import 'package:achintya_clock/satellite.dart';

final radiansPerTick = radians(360 / 60);
final radiansPerHour = radians(360 / 12);

class AchintyaClock extends StatefulWidget {
  const AchintyaClock(this._clockModel);
  final ClockModel _clockModel;
  @override
  _AchintyaClockState createState() => _AchintyaClockState();
}

class _AchintyaClockState extends State<AchintyaClock> {
  DateTime _now = DateTime.now();
  String _temperature = '';
  String _temperatureLow = '';
  String _temperatureHigh = '';
  WeatherCondition _condition = WeatherCondition.sunny;
  String _location = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget._clockModel.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AchintyaClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._clockModel != oldWidget._clockModel) {
      oldWidget._clockModel.removeListener(_updateModel);
      widget._clockModel.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget._clockModel.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget._clockModel.temperatureString;
      _temperatureLow = '${widget._clockModel.low}';
      _temperatureHigh = '${widget._clockModel.highString}';
      _condition = widget._clockModel.weatherCondition;
      _location = widget._clockModel.location;
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

    final TextStyle satelliteTextStyle = TextStyle(
      color: customTheme.backgroundColor,
      fontSize: 26,
      fontFamily: 'monospace',
      fontWeight: FontWeight.w900,
    );

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
        label: "Achintya's clock with time $time",
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
            Satellite(
              colors: Theme.of(context).brightness == Brightness.light ? planetColorsDay : planetColorsNight,
              radius: 8,
              distFromCenter: 96,
              angleRadians: _now.second * radiansPerTick +
                  (_now.millisecond / 1000) * radiansPerTick,
            ),
            Satellite(
              colors: Theme.of(context).brightness == Brightness.light ? planetColorsDay : planetColorsNight,
              radius: 20,
              distFromCenter: 64,
              angleRadians: _now.minute * radiansPerTick +
                  (_now.second / 60) * radiansPerTick,
              showText: _now.minute.toString().padLeft(2, '0'),
              textStyle: satelliteTextStyle,
            ),
            Satellite(
              colors: Theme.of(context).brightness == Brightness.light ? planetColorsDay : planetColorsNight,
              radius: 20,
              distFromCenter: 20,
              angleRadians: _now.hour * radiansPerHour +
                  (_now.minute / 60) * radiansPerHour,
              showText: DateFormat(widget._clockModel.is24HourFormat ? 'HH' : 'hh').format(_now).padLeft(2, '0'),
              textStyle: satelliteTextStyle,
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
