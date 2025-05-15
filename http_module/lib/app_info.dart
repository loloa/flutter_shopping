import 'package:flutter/foundation.dart';

class AppInfo {
  static final String appBaseURL =
      !kReleaseMode ? 'flutter-prep-74de6-default-rtdb.firebaseio.com' : '';
  // Uri.parse('https://your.base.url');
}
