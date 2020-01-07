/*
*  icon to dynamically display weather
*  created by achintya kattemalavadi
*  january 2019
*/

// imports
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

// class header
class WeatherIcon extends StatelessWidget {
  // icon dimension
  final double iconDim = 48.0;

  // map for gradient colors based on condition
  final Map<WeatherCondition, List<Color>> conditionColors = {
    WeatherCondition.cloudy: [Colors.grey, Colors.blueGrey],
    WeatherCondition.foggy: [Colors.grey, Colors.blueGrey],
    WeatherCondition.rainy: [Colors.lightBlueAccent, Colors.teal],
    WeatherCondition.snowy: [Colors.lightBlueAccent, Colors.grey],
    WeatherCondition.sunny: [Colors.deepOrange, Colors.orangeAccent],
    WeatherCondition.thunderstorm: [Colors.amber, Colors.orangeAccent],
    WeatherCondition.windy: [Colors.grey, Colors.blueGrey],
  };

  // condition string
  final WeatherCondition condition;

  // constructor
  WeatherIcon({@required this.condition}) : assert(condition != null);

  // build method
  @override
  Widget build(BuildContext context) {
    // gradient mask
    return ShaderMask(
      // icon
      child: Image.asset(
        "assets/images/" + enumToString(condition) + ".png",
        height: iconDim,
        width: iconDim,
      ),
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: conditionColors[condition],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
    );
  }
}
