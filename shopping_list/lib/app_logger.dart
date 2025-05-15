import 'dart:developer';
import 'package:flutter/foundation.dart';

class AppLog {
  final String logName;
  final bool isActive;
  const AppLog(this.logName, this.isActive);

  static const ntf = AppLog('Notifications', true);
  static const auth = AppLog('Auth', false);
  static const api = AppLog('API', true);
  static const db = AppLog('Database', true);

  void dLog(String message) {
    if (!isActive) {
      return;
    }
    if (!kReleaseMode) {
      log(message, name: 'LOG_$logName'); // Only logs in debug mode
    }
  }

  // Optionally add more specific log types
  void info(String message) => dLog('INFO: $message');
  void warning(String message) => dLog('⚠️ WARNING: $message');
  void error(String message) => dLog('❌ ERROR: $message');
}

/*
AppLog.api.dLog(prettyJson);
AppLog.ntf.log('payload: $payload');
AppLog.api.error('Failed to fetch user data');
AppLog.auth.info('User login successful');

*/
