part of '../../weather_app.dart';

class WeeklyWeatherData {
  final List<DayWeatherData> weekWeatherdata;

  const WeeklyWeatherData({required this.weekWeatherdata});

  factory WeeklyWeatherData.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> dailydData = json['daily'];
    List<DayWeatherData> data = [];
    for (int i = 0; i < (dailydData['time'] as List<dynamic>).length; i++) {
      String day = DateFormat('EEEE')
          .format(
            DateTime.parse(dailydData['time'][i]),
          )
          .substring(0, 3);
      String name = getWeatherNameFromCode(dailydData['weather_code'][i]);
      String image = WeatherIcons.getWeatherIcon(name, false);
      data.add(
        DayWeatherData(
          name: name,
          day: day,
          image: image,
          max: dailydData['temperature_2m_max'][i],
          min: dailydData['temperature_2m_min'][i],
        ),
      );
    }
    return WeeklyWeatherData(weekWeatherdata: data);
  }

  static String getWeatherNameFromCode(int code) {
    if (code == 0) {
      return "Clear";
    } else if (code >= 1 && code <= 3) {
      return "Clouds";
    } else if (code >= 45 && code <= 48) {
      return "Clouds";
    } else if (code >= 51 && code <= 57) {
      return "Drizzle";
    } else if (code >= 61 && code <= 67) {
      return "Rain";
    } else if (code >= 71 && code <= 77) {
      return "Snow";
    } else if (code >= 80 && code <= 82) {
      return "Rain";
    } else if (code >= 95 && code <= 99) {
      return "Thunderstorm";
    } else {
      return "Clear";
    }
  }
}
