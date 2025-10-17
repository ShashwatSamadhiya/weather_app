part of weather_app;

class WeatherAppApiHelperImpl implements WeatherAppApiHelper {
  late NetworkInfo networkInfo;

  WeatherAppApiHelperImpl({
    required this.networkInfo,
  });

  @override
  Future<dartz.Either<WeatherAppException, T>> ensure<T>(
    Future<http.Response> Function() futureGenerator, {
    int delaySeconds = 1,
    int maxAttempts = 4,
    required T Function(dynamic data) parser,
  }) async {
    assert(maxAttempts > 0, "maxAttempts must be greater than 0");
    return await _ensure(
      futureGenerator,
      parser: parser,
      delaySeconds: delaySeconds,
      maxAttempts: maxAttempts,
    );
  }

  Future<dartz.Either<WeatherAppException, T>> _ensure<T>(
    Future<http.Response> Function() futureGenerator, {
    int delaySeconds = 1,
    required T Function(dynamic data) parser,
    int thisAttemptIndex = 0,
    int maxAttempts = 4,
    WeatherAppException? lastFailedException,
  }) async {
    if (maxAttempts <= thisAttemptIndex) {
      return dartz.left(
        lastFailedException ??
            WeatherAppException(
              errorMessage: "Maximum retry attempts exceeded",
            ),
      );
    }
    if (thisAttemptIndex > 0) {
      await Future.delayed(Duration(seconds: delaySeconds));
    }

    try {
      await checkInternetConnection();
      final response = await futureGenerator();
      checkIfStatusCodeIsHttpError(response.statusCode);
      checkIfStatusCodeIsServerError(response.statusCode);
      final result = parseData<T>(
        () => parser(
          response.body,
        ),
      );
      return dartz.Right(result);
    } on NetworkException catch (error) {
      return await _ensure(
        futureGenerator,
        parser: parser,
        delaySeconds: delaySeconds,
        thisAttemptIndex: thisAttemptIndex + 1,
        maxAttempts: maxAttempts,
        lastFailedException: error,
      );
    } on ServerException catch (error) {
      if (error.statusCode != null &&
          (error.statusCode! >= 500 && error.statusCode! < 504)) {
        return await _ensure(
          futureGenerator,
          parser: parser,
          delaySeconds: delaySeconds,
          thisAttemptIndex: thisAttemptIndex + 1,
          maxAttempts: maxAttempts,
          lastFailedException: error,
        );
      } else {
        return dartz.Left(error);
      }
    } on HttpException catch (error) {
      return dartz.Left(error);
    } on http.ClientException catch (error) {
      return dartz.Left(
        NetworkException(errorMessage: error.message),
      );
    } catch (error, stackTrace) {
      log(
        "Unexpected error in WeatherAppApiHelperImpl._ensure: ",
        error: error,
        stackTrace: stackTrace,
      );
      return dartz.Left(
        WeatherAppException(
          errorMessage:
              "An unexpected error occurred. Please try again later. error: $error",
        ),
      );
    }
  }
}

extension WeatherAppApiHelperImplApiErrorCheckExtensions
    on WeatherAppApiHelperImpl {
  Future<void> checkInternetConnection() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException();
    }
  }

  void checkIfStatusCodeIsHttpError(int statusCode) {
    if (statusCode >= 400 && statusCode < 500) {
      throw HttpException(statusCode: statusCode);
    }
  }

  void checkIfStatusCodeIsServerError(int statusCode) {
    if (statusCode >= 500 && statusCode < 600) {
      throw ServerException(statusCode: statusCode);
    }
  }
}

extension WeatherAppApiImplDataParsingExtensions on WeatherAppApiHelperImpl {
  T parseData<T>(T Function() parser) {
    try {
      final result = parser();
      return result;
    } catch (e, st) {
      log("Error in parser$T: ", error: e, stackTrace: st);

      throw ParsingException();
    }
  }
}
