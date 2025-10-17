part of weather_app;

abstract class APIRouteData {
  String get baseApiPath => _baseApiPath;
  String get path;

  Map<String, dynamic>? get queryParams;

  Map<String, String>? get headers;

  dynamic get body;
}
