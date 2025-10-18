import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app launches and shows Weather Details appbar',
      (WidgetTester tester) async {
    app.main();

    await tester.pumpAndSettle(const Duration(seconds: 4));

    expect(find.text('Weather Details'), findsOneWidget);

    final Finder searchIcon = find.byIcon(Icons.search);
    expect(searchIcon, findsOneWidget);
    await tester.tap(searchIcon);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    final Finder tokyoTile = find.text('Tokyo');
    expect(tokyoTile, findsOneWidget);
    await tester.tap(tokyoTile);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    final Finder backButton = find.byTooltip('Back');
    expect(backButton, findsOneWidget);

    await tester.tap(backButton);
    await tester.pumpAndSettle();

    final Finder forecastLabel = find.text('Forecast');
    final Finder mapLabel = find.text('Map');

    expect(forecastLabel, findsOneWidget);
    await tester.tap(forecastLabel);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Forecast').first, findsWidgets);

    expect(mapLabel, findsOneWidget);
    await tester.tap(mapLabel);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(Stack).hitTestable().first, findsWidgets);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    final Finder textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    await tester.enterText(textField, 'a');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    expect(find.text('Please enter a valid city name'), findsOneWidget);
  });
}
