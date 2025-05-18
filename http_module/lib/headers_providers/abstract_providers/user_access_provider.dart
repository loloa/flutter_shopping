enum UserAccessLevel { userCode, remotePassword, all }

abstract class UserAccessProvider {
  String? get userCode;
  String? get remoteUserPassword;
}

class DefaultUserAccessProvider implements UserAccessProvider {
  @override
  String? get userCode => null;

  @override
  String? get remoteUserPassword => null;
}
