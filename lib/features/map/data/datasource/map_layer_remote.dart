part of weather_app;

abstract class MapLayerRemote {
  Future<MapLayerData> getMapLayer(
    int x,
    int y,
    int zoom,
    String mapType,
  );
}
