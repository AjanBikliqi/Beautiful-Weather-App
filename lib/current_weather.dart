import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/weather.dart';
import 'dart:convert';

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({Key? key}) : super(key: key);

  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Weather?>(
          builder: (context, snapshot) {
            if (snapshot != null) {
              Weather? _weather = snapshot.data;
              if (_weather == null) {
                return Text('Error getting weather');
              } else {
                return weatherBox(_weather);
              }
            } else {
              return CircularProgressIndicator();
            }
          },
          future: getCurrentWeather(),
        ),
      ),
    );
  }
}

Widget weatherBox(Weather _weather) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        margin: EdgeInsets.all(10.0),
        child: Text(
          '${_weather.temp.toStringAsFixed(2)} C',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55),
        ),
      ),
      Container(margin: EdgeInsets.all(5.0), child: Text(_weather.description)),
      Container(
          margin: EdgeInsets.all(5.0),
          child: Text('Feels: ${_weather.feelsLike.toStringAsFixed(2)} C')),
      Container(
        margin: EdgeInsets.all(5.0),
        child: Text(
            'H: ${_weather.high.toStringAsFixed(2)} C L:${_weather.low.toStringAsFixed(2)} C'),
      ),
    ],
  );
}

Future<Weather?> getCurrentWeather() async {
  Weather? weather;
  String city = 'Pristina';
  String apiKey = '9233805c2fc2bced2f6ee9e55842ffb4';
  var url =
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    weather = Weather.fromJson(jsonDecode(response.body));
  } else {}
  return weather;
}
