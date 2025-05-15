import 'package:http_module/abstract_client/http_client.dart';
import 'package:http_module/client_decorators/abstract_client_decorator.dart';
import 'package:http_module/data_providers/abstract_providers/auth_provider.dart';

class BasicHTTPClientDecorator extends HttpClientDecorator {
  final AuthorizationProvider _authProvider;

  BasicHTTPClientDecorator(
    HttpClient decoratee, {
    AuthorizationProvider? authProvider,
  }) : _authProvider = authProvider ?? DefaultAuthorizationProvider(),
       super(decoratee);

  @override
  Map<String, String> decorateHeaders(Map<String, String> headers) {
    final decoratedHeaders = Map<String, String>.from(headers);
    decoratedHeaders["Authorization"] =
        "Basic ${_authProvider.encodedAuthorization}";
    return decoratedHeaders;
  }
}
