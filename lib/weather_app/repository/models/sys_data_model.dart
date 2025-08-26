part of weather_app;

class SysDataModel {
  final int type;
  final int? id;
  final String country;
  final int sunrise;
  final int sunset;

  const SysDataModel({
    required this.type,
    this.id,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  factory SysDataModel.fromJson(Map<String, dynamic> json) => SysDataModel(
    type: json['type'] ?? 1,
    id: json['id'],
    country: json['country'],
    sunrise: json['sunrise'],
    sunset: json['sunset'],
  );
}
