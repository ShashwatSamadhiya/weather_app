library;

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
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
part 'repository/models/wind.dart';
part 'repository/models/position.dart';
part 'repository/models/weather_data.dart';
part 'repository/models/current_weather_data.dart';
part 'repository/models/sys_data_model.dart';
part 'repository/models/day_weather_data.dart';
part 'repository/models/week_weather_data.dart';
part 'repository/models/weather_data_by_hour.dart';
part 'repository/models/weather.dart';

part 'view/app.dart';
part 'view/pages/splash.dart';
part 'view/pages/home.dart';

part 'view/widgets/error.dart';
part 'view/widgets/loading.dart';
part 'view/widgets/info_card.dart';
part 'view/widgets/weather_view.dart';
part 'view/widgets/current_weather_ui.dart';
