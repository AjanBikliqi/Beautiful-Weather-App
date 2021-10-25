class Weather {
  final double temp;
  final double feelsLike;
  final double low;
  final double high;
  final String description;
  final String icon;

  Weather(
      {required this.temp,
      required this.feelsLike,
      required this.low,
      required this.high,
      required this.description,
      required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temp: json['main']['temp'] - 273.15 ?? 0,
      feelsLike: json['main']['feels_like'] - 273.15 ?? 0,
      low: json['main']['temp_min'] - 273.15 ?? 0,
      high: json['main']['temp_max'] - 273.15 ?? 0,
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}
