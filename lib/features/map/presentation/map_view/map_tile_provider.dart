part of weather_app;

class WeatherAppTileProvider implements TileProvider {
  late final Tile transitionTile;
  Tile? actualTile;
  final String mapType;
  final int tileSize;
  WeatherAppTileProvider({
    required this.mapType,
    this.tileSize = 256,
  }) {
    transitionTile = Tile(0, 0, Uint8List.fromList([1]));
    actualTile = Tile(0, 0, Uint8List.fromList([1]));
  }

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    zoom = zoom ?? 1;

    if (zoom >= 1 && zoom <= 20) {
      try {
        final uri = Uri.parse(
          "https://tile.openweathermap.org/map/$mapType/$zoom/$x/$y.png?appid=$_apiAccessKey",
        );

        final ByteData imageData = await NetworkAssetBundle(uri).load("");
        final response = MapLayerData.fromByteData(imageData);
        actualTile = Tile(tileSize, tileSize, response.uint8list);
        return actualTile!;
      } catch (e) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: e,
          library: 'WeatherAppTileProvider',
          context: ErrorDescription('while fetching map tile'),
        ));
        return transitionTile;
      }
    }
    return transitionTile;
  }
}
