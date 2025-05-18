import 'package:http_module/abstract_client/http_client.dart';
import 'package:http_module/client_decorators/abstract_client_decorator.dart';
import 'package:http_module/client_decorators/http_client_decorators/auth_http_client_decorator.dart';
import 'package:http_module/headers_providers/abstract_providers/user_access_provider.dart';

class UserPermissionsHTTPClientDecorator extends HttpClientDecorator {
  final UserAccessProvider _userAccessProvider;
  final UserAccessLevel _accessLevel;

  UserPermissionsHTTPClientDecorator(
    HttpClient decoratee, {
    AuthHTTPClientDecorator? authDecorator,
    UserAccessProvider? userAccessProvider,
    UserAccessLevel accessLevel = UserAccessLevel.all,
  }) : _userAccessProvider = userAccessProvider ?? DefaultUserAccessProvider(),
       _accessLevel = accessLevel,
       super(authDecorator ?? AuthHTTPClientDecorator(decoratee));

  @override
  Map<String, String> decorateHeaders(Map<String, String> headers) {
    final decoratedHeaders = Map<String, String>.from(headers);

    switch (_accessLevel) {
      case UserAccessLevel.userCode:
        if (_userAccessProvider.userCode != null) {
          decoratedHeaders["X-Crow-CP-user"] = _userAccessProvider.userCode!;
        }
        break;
      case UserAccessLevel.remotePassword:
        if (_userAccessProvider.remoteUserPassword != null) {
          decoratedHeaders["X-Crow-CP-remote"] =
              _userAccessProvider.remoteUserPassword!;
        }
        break;
      case UserAccessLevel.all:
        if (_userAccessProvider.userCode != null) {
          decoratedHeaders["X-Crow-CP-user"] = _userAccessProvider.userCode!;
        }
        if (_userAccessProvider.remoteUserPassword != null) {
          decoratedHeaders["X-Crow-CP-remote"] =
              _userAccessProvider.remoteUserPassword!;
        }
        break;
    }

    return decoratedHeaders;
  }
}
