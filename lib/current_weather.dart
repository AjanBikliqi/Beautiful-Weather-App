import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/forecast.dart';
import 'models/weather.dart';
import 'dart:convert';
import 'package:weather_app2/location.dart';
import 'package:weather_app2/extensions.dart';

class CurrentWeatherPage extends StatefulWidget {
  final List<Location> locations;
  CurrentWeatherPage(this.locations);

  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState(this.locations);
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  final List<Location> locations;
  final Location location;
  Weather? _weather;

  _CurrentWeatherPageState(List<Location> locations):
      this.locations = locations,
      this.location = locations[0];

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body:
        ListView(
            children: <Widget>[
              currentWeatherViews(this.locations, this.location, this.context),
              forcastViewsHourly(this.location),
              forcastViewsDaily(this.location),
            ]
        )
    );
  }
}
Widget currentWeatherViews(
    List<Location> locations, Location location, BuildContext context) {
  Weather? _weather;

  return FutureBuilder(
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        _weather = snapshot.data as Weather?;
        if (_weather == null) {
          return Text("Error getting weather");
        } else {
          return Column(children: [
            createAppBar(locations, location, context),
            weatherBox(_weather!),
            weatherDetailsBox(_weather),
          ]);
        }
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
    future: getCurrentWeather(location),
  );
}

Widget forcastViewsHourly(Location location) {
  Forecast? _forcast;

  return FutureBuilder(
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        _forcast = snapshot.data as Forecast?;
        if (_forcast == null) {
          return Text("Error getting weather");
        } else {
          return hourlyBoxes(_forcast);
        }
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
    future: getForecast(location),
  );
}

Widget forcastViewsDaily(Location location) {
  Forecast? _forcast;

  return FutureBuilder(
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        _forcast = snapshot.data as Forecast?;
        if (_forcast == null) {
          return Text("Error getting weather");
        } else {
          return dailyBoxes(_forcast);
        }
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
    future: getForecast(location),
  );
}

Widget weatherBox(Weather _weather) {
  return Container(
    padding: const EdgeInsets.all(15.0),
    margin: const EdgeInsets.all(15.0),
    height: 160.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20.0))
    ),
    child: Row(children: [
      Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getWeatherIcon(_weather.icon),
              Container(
                margin: EdgeInsets.all(5.0),
                child: Text(
                  '${_weather.description.capitalizeFirstOfEach}',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.white
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                child: Text(
                  'H: ${_weather.high.toInt()} / L:${_weather.low.toInt()}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
      ),
      Column(
        children: [
          Container(
            child: Text(
              '${_weather.temp.toInt()}',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                  color: Colors.white
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(0),
            child: Text(
              'Feels Like:${_weather.feelsLike.toInt()}',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                  color: Colors.white
              ),
            ),
          ),
        ],
      )
    ],),
  );

}

Future<Weather?> getCurrentWeather(Location location) async {
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
Future getForecast(Location location) async {
  Forecast? forecast;

  String apiKey = '9233805c2fc2bced2f6ee9e55842ffb4';
  String lat = location.lat;
  String lon = location.lon;
  var url =
      "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&appid=$apiKey";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    forecast = Forecast.fromJson(jsonDecode(response.body));
  }
  return forecast;
}

Image getWeatherIcon(String _icon){
  String path = 'icons/the_icons/';
  String imageExtension = '.png';
  return Image.asset(
    path + _icon + imageExtension,
    width: 70,
    height: 70,
  );
}
Image getWeatherIconSmall(String _icon){
  String path = 'icons/the_icons/';
  String imageExtension = '.png';
  return Image.asset(
      path + _icon + imageExtension,
      width: 40,
      height: 40,
  );
}
