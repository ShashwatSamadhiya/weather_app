library weather_app;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'core/theme/theme.dart';
part 'core/error/errors.dart';
part 'core/navigation.dart';

part 'bloc/weather_bloc.dart';
part 'bloc/weather_event.dart';
part 'bloc/weather_state.dart';

part 'utils/icons.dart';

part 'repository/weather_repository.dart';
part 'repository/location_service.dart';
part 'models/wind.dart';
part 'models/position.dart';
part 'models/weather_data.dart';
part 'models/current_weather_data.dart';
part 'models/sys_data_model.dart';
part 'models/day_weather_data.dart';
part 'models/week_weather_data.dart';
part 'models/weather_data_by_hour.dart';
part 'models/weather.dart';
part 'models/map_layer_data.dart';
part 'models/weather_remote_source.dart';

part 'view/app.dart';

part 'view/pages/splash.dart';
part 'view/pages/home.dart';
part 'view/pages/search.dart';

part 'view/widgets/error.dart';
part 'view/widgets/loading.dart';
part 'view/widgets/current_weather/info_card.dart';
part 'view/widgets/current_weather/weather_view.dart';
part 'view/widgets/current_weather/current_weather_ui.dart';
part 'view/widgets/forecast/forecast_view.dart';
part 'view/widgets/forecast/forecast_tile.dart';
part 'view/widgets/city/city_weather.dart';

part 'view/map_view/map_view.dart';
part 'view/map_view/marker_weather_info.dart';
part 'view/map_view/marker_info.dart';
part 'view/map_view/map_tile_provider.dart';
part 'view/map_view/fab_button_data.dart';
