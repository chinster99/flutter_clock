/*
*  main clock class
*  adapted from analog_clock
*  created by achintya kattemalavadi
*  january 2019
*/

// imports
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'dart:async';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'package:intl/intl.dart';

import 'package:flutter_clock_helper/model.dart';

import 'package:achintya_clock/background_circles.dart';
import 'package:achintya_clock/weather_icon.dart';
import 'package:achintya_clock/satellite.dart';

// statefulwidget for achintyaclock
class AchintyaClock extends StatefulWidget {
  const AchintyaClock(this._clockModel);
  final ClockModel _clockModel;
  @override
  _AchintyaClockState createState() => _AchintyaClockState();
}

// state for achintyaclock
class _AchintyaClockState extends State<AchintyaClock> {
  // constants
  final radiansPerTick = radians(360 / 60);
  final radiansPerHour = radians(360 / 12);

  // class vars
  DateTime _now = DateTime.now();
  String _temperature = '';
  String _temperatureLow = '';
  String _temperatureHigh = '';
  WeatherCondition _condition = WeatherCondition.sunny;
  String _location = '';
  Timer _timer;

  // initstate method
  @override
  void initState() {
    super.initState();
    widget._clockModel.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  // change listener on clockmodel update
  @override
  void didUpdateWidget(AchintyaClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._clockModel != oldWidget._clockModel) {
      oldWidget._clockModel.removeListener(_updateModel);
      widget._clockModel.addListener(_updateModel);
    }
  }

  // dispose method
  @override
  void dispose() {
    _timer?.cancel();
    widget._clockModel.removeListener(_updateModel);
    super.dispose();
  }

  // update weather and location info
  void _updateModel() {
    setState(() {
      _temperature = widget._clockModel.temperatureString;
      _temperatureLow = '${widget._clockModel.low}';
      _temperatureHigh = '${widget._clockModel.highString}';
      _condition = widget._clockModel.weatherCondition;
      _location = widget._clockModel.location;
    });
  }

  // update time info once per millisecond
  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      _timer = Timer(
        Duration(milliseconds: 1) - Duration(microseconds: _now.microsecond),
        _updateTime,
      );
    });
  }

  // build method
  @override
  Widget build(BuildContext context) {
    // theme for clock based on light or dark mode
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            accentColor: Colors.deepPurple,
            backgroundColor: Colors.white,
          )
        : Theme.of(context).copyWith(
            accentColor: Colors.amber,
            backgroundColor: Colors.black,
          );

    // time for label
    final time = DateFormat.Hms().format(DateTime.now());

    // text style for info panels
    final sideInfoTextStyle = TextStyle(
      fontFamily: 'nunito',
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.black
          : Colors.white,
    );

    // dateinfo widget
    final dateInfo = DefaultTextStyle(
      style: sideInfoTextStyle,
      child: Text(
        DateFormat.yMMMMEEEEd().format(_now),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );

    // weatherinfo widget
    final weatherInfo = DefaultTextStyle(
      style: sideInfoTextStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WeatherIcon(condition: _condition),
          Text(
            _temperature,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            'Low: ' + _temperatureLow + ', High: ' + _temperatureHigh,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            _location + ", Earth",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );

    // color list for the satellites for light theme
    final planetColorsDay = [
      Colors.teal,
      Colors.blue,
      Colors.deepPurple,
      Colors.red,
    ];

    // color list for the satellites for dark theme
    final planetColorsNight = [
      Colors.redAccent,
      Colors.purpleAccent,
      Colors.lightBlueAccent,
      Colors.tealAccent,
    ];

    // text style and offset for the minute and hour satellites
    final TextStyle satelliteTextStyle = TextStyle(
      color: customTheme.backgroundColor,
      fontSize: 26,
      fontFamily: 'nunito',
      fontWeight: FontWeight.w900,
    );
    final Offset textOffset = Offset(-15, -15);

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: "Achintya's clock with time $time",
        value: time,
      ),
      child: Container(
        color: customTheme.backgroundColor,
        // stack to hold everything on the clock
        child: Stack(
          children: [
            // orbits
            BackgroundCircles(
              orbitsColor: customTheme.accentColor,
            ),

            // second satellite
            Satellite(
              colors: Theme.of(context).brightness == Brightness.light
                  ? planetColorsDay
                  : planetColorsNight,
              radius: 8,
              distFromCenter: 96,
              angleRadians: _now.second * radiansPerTick +
                  (_now.millisecond / 1000) * radiansPerTick,
            ),

            // minute satellite
            Satellite(
              colors: Theme.of(context).brightness == Brightness.light
                  ? planetColorsDay
                  : planetColorsNight,
              radius: 20,
              distFromCenter: 64,
              angleRadians: _now.minute * radiansPerTick +
                  (_now.second / 60) * radiansPerTick,
              showText: _now.minute.toString().padLeft(2, '0'),
              textStyle: satelliteTextStyle,
              textOffset: textOffset,
            ),

            // hour satellite
            Satellite(
              colors: Theme.of(context).brightness == Brightness.light
                  ? planetColorsDay
                  : planetColorsNight,
              radius: 20,
              distFromCenter: 20,
              angleRadians: _now.hour * radiansPerHour +
                  (_now.minute / 60) * radiansPerHour,
              showText:
                  DateFormat(widget._clockModel.is24HourFormat ? 'HH' : 'hh')
                      .format(_now)
                      .padLeft(2, '0'),
              textStyle: satelliteTextStyle,
              textOffset: textOffset,
            ),

            // date
            Positioned(
              right: 0.0,
              top: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: dateInfo,
              ),
            ),

            // weather
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
