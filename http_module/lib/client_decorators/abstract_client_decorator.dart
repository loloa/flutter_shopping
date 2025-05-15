import 'package:http_module/abstract_client/http_client.dart';

abstract class HttpClientDecorator extends HttpClient {
  final HttpClient _decoratee;

  HttpClientDecorator(this._decoratee);

  @override
  Future<HttpResponse<dynamic>> request(
    String endpoint,
    HttpMethod method, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? contentType,
  }) {
    final decoratedHeaders = decorateHeaders(headers ?? {});

    return _decoratee.request(
      endpoint,
      method,
      params: params,
      body: body,
      headers: decoratedHeaders,
      contentType: contentType,
    );
  }

  Map<String, String> decorateHeaders(Map<String, String> headers);
}
