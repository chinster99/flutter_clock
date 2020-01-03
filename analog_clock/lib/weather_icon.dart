import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String condition;
  final Map<String, List<Color>> conditionColors = {
    "cloudy": [Colors.grey, Colors.blueGrey],
    "foggy": [Colors.grey, Colors.blueGrey],
    "rainy": [Colors.lightBlueAccent, Colors.teal],
    "snowy": [Colors.lightBlueAccent, Colors.grey],
    "sunny": [Colors.deepOrange, Colors.orangeAccent],
    "thunderstorm": [Colors.amber, Colors.orangeAccent],
    "windy": [Colors.grey, Colors.blueGrey],
  };
  WeatherIcon({
    @required this.condition
  });
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: Image.asset(
        "assets/images/" + this.condition + ".png",
        height: 56,
        width: 56,
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