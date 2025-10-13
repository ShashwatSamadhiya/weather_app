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
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part '../core/theme/app_theme.dart';
part '../core/error/errors.dart';
part '../core/route/navigation.dart';
part '../core/network/network.dart';

part 'presentation/bloc/weather_bloc.dart';
part 'presentation/bloc/weather_event.dart';
part 'presentation/bloc/weather_state.dart';

part 'presentation/utils/icons.dart';

part 'repository/weather_repository.dart';
part 'repository/location_service.dart';
part 'domain/entities/wind.dart';
part 'domain/entities/position.dart';
part 'domain/entities/weather_data.dart';
part 'domain/entities/current_weather_data.dart';
part 'domain/entities/sys_data_model.dart';
part 'domain/entities/day_weather_data.dart';
part 'domain/entities/week_weather_data.dart';
part 'domain/entities/weather_data_by_hour.dart';
part 'domain/entities/weather.dart';
part 'domain/entities/map_layer_data.dart';
part 'domain/entities/weather_remote_source.dart';

part 'presentation/view/pages/material_app.dart';

part 'presentation/view/pages/splash.dart';
part 'presentation/view/pages/home.dart';
part 'presentation/view/pages/search.dart';

part 'presentation/view/widgets/error.dart';
part 'presentation/view/widgets/loading.dart';
part 'presentation/view/widgets/current_weather/info_card.dart';
part 'presentation/view/widgets/current_weather/weather_view.dart';
part 'presentation/view/widgets/current_weather/current_weather_ui.dart';
part 'presentation/view/widgets/forecast/forecast_view.dart';
part 'presentation/view/widgets/forecast/forecast_tile.dart';
part 'presentation/view/widgets/city/city_weather.dart';

part 'presentation/view/map_view/map_view.dart';
part 'presentation/view/map_view/marker_weather_info.dart';
part 'presentation/view/map_view/marker_info.dart';
part 'presentation/view/map_view/map_tile_provider.dart';
part 'presentation/view/map_view/fab_button_data.dart';
