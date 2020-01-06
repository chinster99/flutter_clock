/*
*  icon to dynamically display weather
*  created by achintya kattemalavadi
*  january 3, 2019
*/

// imports
import 'package:flutter/material.dart';

// class header
class WeatherIcon extends StatelessWidget {

  // icon dimension
  final double iconDim = 48.0;

  // map for gradient colors based on condition
  final Map<String, List<Color>> conditionColors = {
    "cloudy": [Colors.grey, Colors.blueGrey],
    "foggy": [Colors.grey, Colors.blueGrey],
    "rainy": [Colors.lightBlueAccent, Colors.teal],
    "snowy": [Colors.lightBlueAccent, Colors.grey],
    "sunny": [Colors.deepOrange, Colors.orangeAccent],
    "thunderstorm": [Colors.amber, Colors.orangeAccent],
    "windy": [Colors.grey, Colors.blueGrey],
  };

  // condition string
  final String condition;

  // constructor
  WeatherIcon({
    @required this.condition
  });

  // build method
  @override
  Widget build(BuildContext context) {
    // gradient mask
    return ShaderMask(
      // icon
      child: Image.asset(
        "assets/images/" + this.condition + ".png",
        height: iconDim,
        width: iconDim,
      ),
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: conditionColors[this.condition],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
    );
  }
}