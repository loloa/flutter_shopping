import 'package:http/http.dart' as http;
import 'package:http_module/client/abstract_client/http_client.dart';
import 'dart:convert';

class HttpDotDartClient extends HttpClient {
  final http.Client _client;

  HttpDotDartClient([http.Client? client]) : _client = client ?? http.Client();

  @override
  Future<HttpResponse<dynamic>> performRequest(
    String endpoint,
    HttpMethod method, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? contentType,
  }) async {
    Uri uri = Uri.parse(endpoint);
    if (params != null) {
      uri = uri.replace(
        queryParameters: params.map((k, v) => MapEntry(k, v.toString())),
      );
    }

    final finalHeaders = prepareHeaders(
      method: method,
      headers: headers,
      contentType: contentType,
      formData: body?.toString(),
    );
    try {
      late http.Response httpResponse;

      switch (method) {
        case HttpMethod.get:
          httpResponse = await _client.get(uri, headers: finalHeaders);
          break;
        case HttpMethod.post:
          httpResponse = await _client.post(
            uri,
            headers: finalHeaders,
            body: body,
          );
          break;
        case HttpMethod.put:
          httpResponse = await _client.put(
            uri,
            headers: finalHeaders,
            body: body,
          );
          break;
        case HttpMethod.patch:
          httpResponse = await _client.patch(
            uri,
            headers: finalHeaders,
            body: body,
          );
          break;
        case HttpMethod.delete:
          httpResponse = await _client.delete(
            uri,
            headers: finalHeaders,
            body: body,
          );
          break;
      }
      // Parse JSON response if possible
      dynamic responseData = httpResponse.body;
      if (httpResponse.body.isNotEmpty) {
        try {
          responseData = jsonDecode(httpResponse.body);
        } catch (e) {
          // If not JSON, keep the original body
        }
      }
      return HttpResponse(
        data: responseData,
        statusCode: httpResponse.statusCode,
        headers: httpResponse.headers,
      );
    } catch (e) {
      if (e is http.ClientException) {
        throw HttpException(
          500, // http package doesn't provide status code in exceptions
          'HTTP error: ${e.message}',
        );
      }
      rethrow;
    }
  }
}
/*

final customClient = http.Client();
final client = HttpDotDartClient(customClient);

*/