part of weather_app;

class MapRepositoryImpl implements MapRepository {
  final MapLayerRemote remote;
  final NetworkInfo networkInfo;

  MapRepositoryImpl({
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<dartz.Either<WeatherAppException, MapLayerData>> getMapLayer(
    int x,
    int y,
    int zoom,
    String mapType,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final MapLayerData mapLayerData =
            await remote.getMapLayer(x, y, zoom, mapType);
        return dartz.Right(mapLayerData);
      } on WeatherAppException catch (e) {
        return dartz.Left(e);
      } catch (error, stackTrace) {
        // Log the error and stack trace for debugging purposes
        print('Unexpected error: $error, StackTrace: $stackTrace');
        return dartz.Left(WeatherAppException());
      }
    } else {
      return dartz.Left(NetworkException());
    }
  }
}
