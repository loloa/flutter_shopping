import 'package:http/http.dart' as http;
import 'package:http_module/abstract_client/http_client.dart';

class HttpDotDartClient extends HttpClient {
  final http.Client _client;

  HttpDotDartClient([http.Client? client]) : _client = client ?? http.Client();

  @override
  Future<HttpResponse<dynamic>> request(
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

    return HttpResponse(
      data: httpResponse.body,
      statusCode: httpResponse.statusCode,
      headers: httpResponse.headers,
    );
  }
}
/*

final customClient = http.Client();
final client = HttpDotDartClient(customClient);

*/