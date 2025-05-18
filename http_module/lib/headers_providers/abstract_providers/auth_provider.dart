import 'package:http_module/app_info.dart';

abstract class AuthorizationProvider {
  String get encodedAuthorization;
}

class DefaultAuthorizationProvider implements AuthorizationProvider {
  @override
  String get encodedAuthorization => AppInfo.encodedAuthorization;
}
