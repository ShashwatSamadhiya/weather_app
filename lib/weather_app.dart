library weather_app;

import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart' as dartz;
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'injection_container.dart';

part 'core/error/errors.dart';
part 'core/location/location_service.dart';
part 'core/network/network.dart';
part 'core/route/navigation.dart';
part 'core/theme/app_theme.dart';

part 'features/weather/presentation/bloc/weather_bloc.dart';
part 'features/weather/presentation/bloc/weather_event.dart';
part 'features/weather/presentation/bloc/weather_state.dart';
part 'features/weather/presentation/utils/icons.dart';

part 'features/weather/data/datasource/weather_remote_data_source_impl.dart';

part 'features/weather/data/repository/weather_repository_impl.dart';

part 'features/weather/domain/entities/wind.dart';
part 'features/weather/domain/entities/position.dart';
part 'features/weather/domain/entities/weather_data.dart';
part 'features/weather/domain/entities/current_weather_data.dart';
part 'features/weather/domain/entities/sys_data_model.dart';
part 'features/weather/domain/entities/day_weather_data.dart';
part 'features/weather/domain/entities/week_weather_data.dart';
part 'features/weather/domain/entities/weather_data_by_hour.dart';
part 'features/weather/domain/entities/weather.dart';
part 'features/map/domain/entities/map_layer_data.dart';
part 'features/weather/data/datasource/weather_remote_source.dart';

part 'features/weather/presentation/view/pages/material_app.dart';

part 'features/weather/presentation/view/pages/splash.dart';
part 'features/weather/presentation/view/pages/home.dart';
part 'features/weather/presentation/view/pages/search.dart';

part 'features/weather/presentation/view/widgets/error.dart';
part 'features/weather/presentation/view/widgets/loading.dart';
part 'features/weather/presentation/view/widgets/current_weather/info_card.dart';
part 'features/weather/presentation/view/widgets/current_weather/weather_view.dart';
part 'features/weather/presentation/view/widgets/current_weather/current_weather_ui.dart';
part 'features/weather/presentation/view/widgets/forecast/forecast_view.dart';
part 'features/weather/presentation/view/widgets/forecast/forecast_tile.dart';
part 'features/weather/presentation/view/widgets/city/city_weather.dart';

part 'features/map/presentation/map_view/map_view.dart';
part 'features/map/presentation/map_view/marker_weather_info.dart';
part 'features/map/presentation/map_view/marker_info.dart';
part 'features/map/presentation/map_view/map_tile_provider.dart';
part 'features/map/presentation/map_view/fab_button_data.dart';

part 'features/weather/domain/repositories/weather_repository.dart';

part 'features/weather/domain/usecases/weather_usecase.dart';
part 'features/weather/domain/usecases/weather_params.dart';
part 'features/weather/domain/usecases/weekly_weather.dart';
part 'features/weather/domain/usecases/city_weather.dart';
part 'features/weather/domain/usecases/current_weather.dart';

part 'features/map/data/datasource/map_layer_remote.dart';
part 'features/map/data/datasource/map_layer_remote_impl.dart';
part 'features/map/domain/repositories/map_repository.dart';
part 'features/map/data/repository/map_layer_impl.dart';
