part of weather_app;

class MapLayerRemoteImpl implements MapLayerRemote {
  late NetworkInfo networkInfo;

  MapLayerRemoteImpl({
    required this.networkInfo,
  });

  final String _mapLayerBaseApiPath = 'https://tile.openweathermap.org/map';

  Future<void> checkInternetConnection() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException();
    }
  }

  @override
  Future<MapLayerData> getMapLayer(
    int x,
    int y,
    int zoom,
    String mapType,
  ) async {
    await checkInternetConnection();
    try {
      final uri = Uri.parse(
        "$_mapLayerBaseApiPath/$mapType/$zoom/$x/$y.png?appid=${WeatherRemoteDataSourceImpl._apiAccessKey}",
      );

      final ByteData imageData = await NetworkAssetBundle(uri).load("");
      return MapLayerData.fromByteData(imageData);
    } catch (e) {
      throw ServerException();
    }
  }
}
