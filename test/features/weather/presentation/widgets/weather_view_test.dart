import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/weather_app.dart';

import '../../../../helper/model_read.dart';
import 'weather_view_test.mocks.dart';

@GenerateMocks([WeatherAppBloc])
void main() {
  late MockWeatherAppBloc mockBloc;

  setUp(() {
    mockBloc = MockWeatherAppBloc();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<WeatherAppBloc>.value(
        value: mockBloc,
        child: const WeatherView(),
      ),
    );
  }

  testWidgets('calls getWeatherData (dispatch event) on init', (tester) async {
    when(mockBloc.state).thenReturn(
      const WeatherLoadingState(type: WeatherStateType.currentWeather),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    verify(mockBloc.add(any)).called(1);
  });

  testWidgets('shows loading screen initially', (tester) async {
    when(mockBloc.state).thenReturn(
      const WeatherLoadingState(type: WeatherStateType.currentWeather),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.text('fetching weather data...'), findsOneWidget);
  });

  testWidgets('shows error widget when WeatherErrorState emitted',
      (tester) async {
    final error = WeatherAppException(errorMessage: 'Failed to load data');
    when(mockBloc.state).thenReturn(
      const WeatherLoadingState(type: WeatherStateType.currentWeather),
    );
    when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([
          WeatherErrorState(
            type: WeatherStateType.currentWeather,
            error: error,
          ),
        ]));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    expect(find.text('Failed to load data'), findsOneWidget);
  });

  testWidgets(
      'shows CurrentWeatherUi when CurrentWeatherDataLoadedState emitted',
      (tester) async {
    final weatherData = CurrentWeatherData.fromJson(
        jsonDecode(modelReaderHelper('current_weather_data.json')));
    when(mockBloc.state).thenReturn(
      const WeatherLoadingState(type: WeatherStateType.currentWeather),
    );
    when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([
          CurrentWeatherDataLoadedState(
            type: WeatherStateType.currentWeather,
            weatherData: weatherData,
          ),
        ]));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.byType(CurrenWeatherUi), findsOneWidget);
  });
}
