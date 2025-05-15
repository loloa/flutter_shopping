import 'package:dio/dio.dart';
import 'package:http_module/abstract_client/http_client.dart';

class DioHttpClient extends HttpClient {
  final Dio _dio;

  DioHttpClient([Dio? dio]) : _dio = dio ?? Dio();

  @override
  Future<HttpResponse<dynamic>> request(
    String endpoint,
    HttpMethod method, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? contentType,
  }) async {
    final finalHeaders = prepareHeaders(
      method: method,
      headers: headers,
      contentType: contentType,
      formData: body?.toString(),
    );

    final options = Options(
      method: method.name.toUpperCase(),
      headers: finalHeaders,
    );

    Response response;

    switch (method) {
      case HttpMethod.get:
        response = await _dio.get(
          endpoint,
          queryParameters: params,
          options: options,
        );
        break;
      case HttpMethod.post:
        response = await _dio.post(endpoint, data: body, options: options);
        break;
      case HttpMethod.put:
        response = await _dio.put(endpoint, data: body, options: options);
        break;
      case HttpMethod.patch:
        response = await _dio.patch(endpoint, data: body, options: options);
        break;
      case HttpMethod.delete:
        response = await _dio.delete(endpoint, data: body, options: options);
        break;
    }

    return HttpResponse(
      data: response.data,
      statusCode: response.statusCode ?? 0,
      headers: Map<String, String>.from(
        response.headers.map.map((k, v) => MapEntry(k, v.join(','))),
      ),
    );
  }
}

/*

final dio = Dio(BaseOptions(connectTimeout: Duration(seconds: 5)));
final client = DioHttpClient(dio);
*/
class Testclass {}
