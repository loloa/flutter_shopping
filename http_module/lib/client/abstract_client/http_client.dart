import '../../api_error/api_error_behavior.dart';
import '../../api_error/api_error_bahavior_config.dart';

class HttpException implements Exception {
  final int statusCode;
  final String message;

  HttpException(this.statusCode, this.message);
}

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

  // Request method to handle errors centrally
  Future<HttpResponse<dynamic>> request(
    String endpoint,
    HttpMethod method, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? contentType,
  }) async {
    try {
      // Call the implementation method that subclasses will override
      return await performRequest(
        endpoint,
        method,
        params: params,
        body: body,
        headers: headers,
        contentType: contentType,
      );
    } catch (e) {
      // Handle errors based on configuration
      if (e is HttpException) {
        throw ApiError(
          e.statusCode,
          e.message,
          getErrorBehavior(endpoint, e.statusCode, method),
        );
      }

      rethrow;
    }
  }

  // Abstract method for implementations to override
  Future<HttpResponse<dynamic>> performRequest(
    String endpoint,
    HttpMethod method, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? contentType,
  });

  // Find the appropriate error behavior based on URL, method, and status code
  ApiErrorBehavior getErrorBehavior(
    String url,
    int statusCode,
    HttpMethod method,
  ) {
    // Try to match with specific method first

    for (final entry in errorBehaviorMap.entries) {
      if (entry.key.method == method.name.toUpperCase() &&
          url.contains(entry.key.path) &&
          entry.value.containsKey(statusCode)) {
        return entry.value[statusCode]!;
      }
    }
    // Default behavior
    return ApiErrorBehavior.showMessage;
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
