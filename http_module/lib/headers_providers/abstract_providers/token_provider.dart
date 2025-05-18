abstract class TokenProvider {
  String get token;
}

class DefaultTokenProvider implements TokenProvider {
  @override
  String get token => "default-token-value"; // This will be implemented properly later
}
