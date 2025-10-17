part of weather_app;

class WeatherAppException extends Error {
  final String errorMessage;

  WeatherAppException({
    this.errorMessage = "An unexpected error occurred. Please try again later.",
  });
}

class ServerException extends WeatherAppException {
  int? statusCode;
  ServerException({
    this.statusCode,
    super.errorMessage =
        "An error occurred while communicating with the server. Please try again later.",
  });
}

class HttpException extends WeatherAppException {
  int? statusCode;
  HttpException({
    this.statusCode,
    super.errorMessage =
        "An HTTP error occurred. Please try again with proper data or try again later.",
  });
}

class ParsingException extends WeatherAppException {
  ParsingException({
    super.errorMessage =
        "Data not in proper format. Unable to process the information received.",
  });
}

class NetworkException extends WeatherAppException {
  NetworkException({
    super.errorMessage =
        "No internet connection. Please check your network settings and try again.",
  });
}

class LocationPermissionException extends WeatherAppException {
  LocationPermissionException({
    super.errorMessage =
        "Location permission denied. Please enable location services in your device settings.",
  });
}
