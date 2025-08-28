part of weather_app;

class MapLayerData {
  final Uint8List uint8list;

  const MapLayerData({required this.uint8list});

  factory MapLayerData.fromByteData(ByteData byteData) {
    final Uint8List bytes = byteData.buffer.asUint8List();
    return MapLayerData(uint8list: bytes);
  }
}
