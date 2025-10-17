part of weather_app;

abstract class WeatherAppApiHelper {
  Future<dartz.Either<WeatherAppException, T>> ensure<T>(
    Future<http.Response> Function() futureGenerator, {
    int delaySeconds = 1,
    int maxAttempts = 4,
    required T Function(dynamic data) parser,
  });
}
