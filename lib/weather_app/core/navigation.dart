part of '../weather_app.dart';

class WeatherAppNavigation {
  static WeatherAppNavigation? _instance;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigatorKey => navigatorKey.currentState!;

  WeatherAppNavigation._();

  static WeatherAppNavigation get instance {
    _instance ??= WeatherAppNavigation._();
    return _instance!;
  }
}

extension Navigation on WeatherAppNavigation {
  Future<T?> push<T>(Widget page) {
    return _navigatorKey.push<T>(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return _navigatorKey.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  Future<T?> pushReplacementNamed<T>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigatorKey.pushReplacementNamed<T, dynamic>(
      routeName,
      arguments: arguments,
    );
  }

  Future<T?> pushReplacement<T>(Widget page) {
    return _navigatorKey.pushReplacement<T, dynamic>(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return _navigatorKey.pushAndRemoveUntil<T>(
      MaterialPageRoute(
        builder: (_) => page,
      ),
      (route) => false,
    );
  }

  void pop<T>([T? result]) {
    return _navigatorKey.pop(
      result,
    );
  }
}
