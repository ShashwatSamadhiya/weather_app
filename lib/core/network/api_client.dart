part of weather_app;

abstract class ApiClient {
  Future<http.Response> getRequest(
    APIRouteData route,
  );

  Future<http.Response> postRequest(
    APIRouteData route,
  );

  Future<http.Response> putRequest(
    APIRouteData route,
  );

  Future<http.Response> deleteRequest(
    APIRouteData route,
  );
}

class ApiClientImpl implements ApiClient {
  final http.Client httpClient;

  ApiClientImpl({
    required this.httpClient,
  });

  @override
  Future<http.Response> getRequest(
    APIRouteData route,
  ) async {
    final uri = Uri.parse(route.baseApiPath + route.path)
        .replace(queryParameters: route.queryParams);
    return await httpClient.get(
      uri,
      headers: route.headers,
    );
  }

  @override
  Future<http.Response> postRequest(
    APIRouteData route,
  ) async {
    final uri =
        Uri.parse(route.path).replace(queryParameters: route.queryParams);
    return await httpClient.post(
      uri,
      headers: route.headers,
      body: route.body,
    );
  }

  @override
  Future<http.Response> putRequest(
    APIRouteData route,
  ) async {
    final uri =
        Uri.parse(route.path).replace(queryParameters: route.queryParams);
    return await httpClient.put(
      uri,
      headers: route.headers,
      body: route.body,
    );
  }

  @override
  Future<http.Response> deleteRequest(
    APIRouteData route,
  ) async {
    final uri =
        Uri.parse(route.path).replace(queryParameters: route.queryParams);
    return await httpClient.delete(
      uri,
      headers: route.headers,
    );
  }
}
