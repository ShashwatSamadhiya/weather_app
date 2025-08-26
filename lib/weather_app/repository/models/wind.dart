part of weather_app;

class Wind {
  final double speed;
  final int deg;
  final double? gust;

  const Wind({required this.speed, required this.deg, this.gust});

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
    speed: (json['speed'] as num).toDouble(),
    deg: json['deg'],
    gust: (json['gust'] as num?)?.toDouble(),
  );
}
