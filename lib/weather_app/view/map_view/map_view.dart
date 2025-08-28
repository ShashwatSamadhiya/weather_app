part of weather_app;

class WeatherMapScreen extends StatefulWidget {
  const WeatherMapScreen({super.key});

  @override
  State<WeatherMapScreen> createState() => _WeatherMapScreenState();
}

class _WeatherMapScreenState extends State<WeatherMapScreen> {
  late LatLng _userLocation;
  final ValueNotifier<LatLng?> _selectedLocation = ValueNotifier(null);
  late CameraPosition initialCameraPosition;
  final Completer<GoogleMapController> _mapController = Completer();
  final ValueNotifier<FabButtonType> _selectedMapLayerType =
      ValueNotifier(FabButtonType.temperature);

  @override
  void initState() {
    _userLocation = const LatLng(0.0, 0.0);
    initialCameraPosition = CameraPosition(target: _userLocation, zoom: 5);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserLocation();
    });
    super.initState();
  }

  void getUserLocation() {
    context.read<WeatherAppBloc>().add(CurrentLocationEvent());
  }

  Future<void> updateUserLocation(LatLng newLocation) async {
    _userLocation = newLocation;
    initialCameraPosition = CameraPosition(target: _userLocation, zoom: 17);
    (await _mapController.future).animateCamera(
      CameraUpdate.newCameraPosition(initialCameraPosition),
    );
  }

  Marker getMarkerObject(LatLng position, {bool isUserLocation = true}) {
    return Marker(
      markerId: isUserLocation
          ? const MarkerId('userLocation')
          : const MarkerId('selectedLocation'),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        isUserLocation ? BitmapDescriptor.hueRed : BitmapDescriptor.hueViolet,
      ),
    );
  }

  Set<Marker> _getMapMarkers() {
    final markers = <Marker>{};
    if (_userLocation.latitude != 0.0 && _userLocation.longitude != 0.0) {
      markers.add(
        getMarkerObject(_userLocation),
      );
    }
    if (_selectedLocation.value != null) {
      markers.add(
        getMarkerObject(
          _selectedLocation.value!,
          isUserLocation: false,
        ),
      );
    }
    return markers;
  }

  void _onTap(LatLng latLng) {
    _selectedLocation.value = latLng;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      builder: (ctx) {
        return MarkerInfo(
          coordinates: PositionCoordinates(
            latitude: latLng.latitude,
            longitude: latLng.longitude,
          ),
        );
      },
    );
  }

  Set<TileOverlay> getLayerTile() {
    if (_selectedMapLayerType.value == FabButtonType.temperature) {
      return {
        TileOverlay(
          tileOverlayId: const TileOverlayId('tempLayer'),
          tileProvider: WeatherAppTileProvider(
            mapType: 'temp_new',
          ),
          zIndex: 1,
          // transparency: 0.5,
        ),
      };
    } else if (_selectedMapLayerType.value == FabButtonType.precipitation) {
      return {
        TileOverlay(
          tileOverlayId: const TileOverlayId('precipitationLayer'),
          tileProvider: WeatherAppTileProvider(
            mapType: 'precipitation_new',
          ),
          zIndex: 1,
        ),
      };
    }
    return {};
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        _selectedMapLayerType.value =
            _selectedMapLayerType.value == FabButtonType.temperature
                ? FabButtonType.precipitation
                : FabButtonType.temperature;
        setState(() {});
      },
      isExtended: true,
      child: ValueListenableBuilder(
        valueListenable: _selectedMapLayerType,
        builder: (ctx, value, child) {
          return Icon(
            _selectedMapLayerType.value == FabButtonType.temperature
                ? Icons.local_fire_department
                : Icons.cloud,
          );
        },
      ),
    );
  }

  Widget _googleMapWidget() {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _selectedLocation,
        builder: (context, LatLng? value, child) {
          return GoogleMap(
            onMapCreated: (controller) => _mapController.complete(controller),
            initialCameraPosition:
                CameraPosition(target: _userLocation, zoom: 6),
            markers: _getMapMarkers(),
            onTap: _onTap,
            tileOverlays: getLayerTile(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget builder() {
    return BlocConsumer<WeatherAppBloc, WeatherState>(
      listener: (context, state) {
        if (state is LocationPermissionState) {
          updateUserLocation(
            LatLng(state.coordinates.latitude, state.coordinates.longitude),
          );
        }
      },
      buildWhen: (previous, current) {
        return current.type == WeatherStateType.location;
      },
      builder: (BuildContext context, WeatherState state) {
        if (state is WeatherErrorState) {
          return ErrorWidget(
            errorMessage: state.error.errorMessage,
            onRetry: getUserLocation,
          );
        }
        return _googleMapWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: builder(),
    );
  }
}
