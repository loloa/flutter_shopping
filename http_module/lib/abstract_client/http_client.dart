enum HttpMethod { get, post, put, patch, delete }

class HttpResponse<T> {
  final T data;
  final int statusCode;
  final Map<String, String> headers;

  HttpResponse({
    required this.data,
    required this.statusCode,
    required this.headers,
  });
}

abstract class HttpClient {
  Future<HttpResponse<dynamic>> request(
    String endpoint,
    HttpMethod method, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? contentType,
  });

  Map<String, String> prepareHeaders({
    required HttpMethod method,
    Map<String, String>? headers,
    String? contentType,
    dynamic formData,
  }) {
    final finalHeaders = Map<String, String>.from(headers ?? {});

    // Only add default JSON content type when method implies body
    final needsJsonContentType = switch (method) {
      HttpMethod.post ||
      HttpMethod.put ||
      HttpMethod.patch ||
      HttpMethod.delete => true,
      _ => false,
    };

    if (contentType != null) {
      finalHeaders['Content-Type'] = contentType;
    } else if (needsJsonContentType && formData is String) {
      finalHeaders['Content-Type'] = 'application/json';
    }

    return finalHeaders;
  }
}
/*

final HttpClient client = DioHttpClient(Dio()); // or HttpDotDartClient(http.Client());

final response = await client.request(
  'https://api.example.com/user',
  DioMethod.get,
);

print(response.statusCode);
print(response.data);

*/

class TestClass {}
