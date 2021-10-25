import 'package:flutter/material.dart';
import 'package:weather_app2/current_weather.dart';
import 'package:weather_app2/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
List<Location> locations =
    Location(city: 'Pristina', country: 'Kosovo', lat: '42.6629', lon: '21.1655') as List<Location>;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CurrentWeatherPage(locations),
    );
  }
}
