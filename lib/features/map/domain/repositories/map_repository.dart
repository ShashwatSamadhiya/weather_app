part of weather_app;

abstract class MapRepository {
  Future<dartz.Either<WeatherAppException, MapLayerData>> getMapLayer(
    int x,
    int y,
    int zoom,
    String mapType,
  );
}
