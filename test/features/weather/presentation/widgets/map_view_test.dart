import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/weather_app.dart';

import 'weather_view_test.mocks.dart';

@GenerateMocks([WeatherAppBloc])
void main() {
  late MockWeatherAppBloc mockBloc;

  setUp(() {
    mockBloc = MockWeatherAppBloc();
    when(mockBloc.state)
        .thenReturn(const WeatherLoadingState(type: WeatherStateType.location));
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<WeatherAppBloc>.value(
        value: mockBloc,
        child: const WeatherMapScreen(),
      ),
    );
  }

  testWidgets('shows GoogleMap initially', (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    expect(find.byType(GoogleMap), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('adds CurrentLocationEvent when initialized', (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    verify(mockBloc.add(any)).called(1);
  });

  testWidgets('shows error widget when WeatherErrorState is emitted',
      (tester) async {
    final error = WeatherAppException(errorMessage: 'Location failed');
    when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([
          WeatherErrorState(
            type: WeatherStateType.location,
            error: error,
          ),
        ]));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    expect(find.text('Location failed'), findsOneWidget);
  });

  testWidgets('updates user location when LocationPermissionState emitted',
      (tester) async {
    final position = PositionCoordinates(latitude: 12.34, longitude: 56.78);
    when(mockBloc.state).thenReturn(
      const WeatherLoadingState(type: WeatherStateType.location),
    );
    when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([
          LocationPermissionState(
            type: WeatherStateType.location,
            coordinates: position,
          ),
        ]));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    expect(find.byType(GoogleMap), findsOneWidget);
  });

  // testWidgets('tapping map opens bottom sheet', (tester) async {
  //   when(mockBloc.state).thenReturn(
  //     const WeatherLoadingState(type: WeatherStateType.location),
  //   );
  //   when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

  //   await tester.pumpWidget(makeTestableWidget());
  //   await tester.pumpAndSettle();

  //   final googleMapFinder = find.byType(GoogleMap);
  //   expect(googleMapFinder, findsOneWidget);

  //   final googleMapWidget = tester.widget<GoogleMap>(googleMapFinder);
  //   googleMapWidget.onTap?.call(const LatLng(20.0, 77.0));

  //   await tester.pumpAndSettle();

  //   expect(find.byType(MarkerInfo), findsOneWidget);
  // });
  testWidgets('tapping FAB toggles layer icon', (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    final fabFinder = find.byType(FloatingActionButton);
    expect(find.byIcon(Icons.local_fire_department), findsOneWidget);

    await tester.tap(fabFinder);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.cloud), findsOneWidget);
  });
}
