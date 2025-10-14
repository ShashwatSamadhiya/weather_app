part of weather_app;

abstract class WeatherUseCase<T, Params> {
  Future<dartz.Either<WeatherAppException, T>> call(Params params);
}
