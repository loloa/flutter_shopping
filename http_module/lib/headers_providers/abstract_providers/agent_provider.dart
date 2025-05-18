abstract class PlatformInfoProvider {
  String get userAgent;
  String get language;
}

class DefaultPlatformInfoProvider implements PlatformInfoProvider {
  @override
  String get userAgent => "Flutter-App"; // Will be platform name (iOS/Android)

  @override
  String get language => "en-US"; // Will be device language
}
