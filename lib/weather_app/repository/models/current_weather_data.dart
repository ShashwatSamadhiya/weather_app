part of '../../weather_app.dart';

class CurrentWeatherData {
  final PositionCoordinates coord;
  final List<WeatherDataModel> weather;
  final String base;
  final WeatherDataModel main;
  final int? visibility;
  final Wind wind;
  final int clouds;
  final int dt;
  final SysDataModel sys;
  final int timezone;
  final int id;
  final String name;
  final int cod;
  final String day;
  final String image;

  const CurrentWeatherData({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
    required this.image,
    required this.day,
  });

  factory CurrentWeatherData.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherData(
      coord: PositionCoordinates(
        longitude: (json['coord']['lon'] as num).toDouble(),
        latitude: (json['coord']['lat'] as num).toDouble(),
      ),
      weather: (json['weather'] as List)
          .map((e) => WeatherDataModel.fromJson(e))
          .toList(),
      base: json['base'],
      main: WeatherDataModel.fromJson(json['main']),
      visibility: json['visibility'],
      wind: Wind.fromJson(json['wind']),
      clouds: json['clouds']['all'],
      dt: json['dt'],
      sys: SysDataModel.fromJson(json['sys']),
      timezone: json['timezone'],
      id: json['id'],
      name: json['name'],
      cod: json['cod'],
      day: DateFormat("EEEE dd MMMM").format(DateTime.now()),
      image: WeatherIcons.getWeatherIcon(json["weather"][0]["main"].toString()),
    );
  }
}
