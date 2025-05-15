import 'package:flutter/foundation.dart';
import 'dart:convert';

class AppInfo {
  static final String appBaseURL =
      !kReleaseMode ? 'flutter-prep-74de6-default-rtdb.firebaseio.com' : '';

  static String get encodedAuthorization {
    const secretId = 'absdf';
    const secretIdentifier = 'secret_678';
    final authString = '$secretIdentifier:$secretId';
    final authBytes = utf8.encode(authString);
    return base64.encode(authBytes);
  }
}
