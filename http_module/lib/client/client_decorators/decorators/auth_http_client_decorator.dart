import 'package:http_module/client/abstract_client/http_client.dart';
import 'package:http_module/client/client_decorators/abstract_client_decorator.dart';
import 'package:http_module/headers_providers/abstract_providers/token_provider.dart';
import 'package:http_module/headers_providers/abstract_providers/agent_provider.dart';

class AuthHTTPClientDecorator extends HttpClientDecorator {
  final TokenProvider _tokenProvider;
  final PlatformInfoProvider _platformInfoProvider;

  AuthHTTPClientDecorator(
    HttpClient decoratee, {
    TokenProvider? tokenProvider,
    PlatformInfoProvider? platformInfoProvider,
  }) : _tokenProvider = tokenProvider ?? DefaultTokenProvider(),
       _platformInfoProvider =
           platformInfoProvider ?? DefaultPlatformInfoProvider(),
       super(decoratee);

  @override
  Map<String, String> decorateHeaders(Map<String, String> headers) {
    final decoratedHeaders = Map<String, String>.from(headers);
    decoratedHeaders["Authorization"] = _tokenProvider.token;
    decoratedHeaders["User-Agent"] = _platformInfoProvider.userAgent;
    decoratedHeaders["X-Crow-Language"] = _platformInfoProvider.language;
    return decoratedHeaders;
  }
}
