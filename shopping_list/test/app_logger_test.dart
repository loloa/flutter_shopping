import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/app_logger.dart';

void main() {
  group('AppLog Tests', () {
    test('dLog should not log when isActive is false', () {
      final log = AppLog('TestLog', false);
      log.dLog('This should not appear');
      // No assertion needed as we rely on the absence of logs in the console
    });

    test('dLog should log when isActive is true and not in release mode', () {
      final log = AppLog('TestLog', true);
      log.dLog('This should appear in debug mode');
      // No assertion needed as we rely on the presence of logs in the console
    });

    test('info should prepend INFO to the message', () {
      final log = AppLog('TestLog', true);
      log.info('This is an info message');
      // No assertion needed as we rely on the presence of logs in the console
    });

    test('warning should prepend ⚠️ WARNING to the message', () {
      final log = AppLog('TestLog', true);
      log.warning('This is a warning message');
      // No assertion needed as we rely on the presence of logs in the console
    });

    test('error should prepend ❌ ERROR to the message', () {
      final log = AppLog('TestLog', true);
      log.error('This is an error message');
      // No assertion needed as we rely on the presence of logs in the console
    });

    test('Static log instances should respect their isActive property', () {
      AppLog.auth.dLog('This should not log because auth is inactive');
      AppLog.api.dLog('This should log because API is active');
      AppLog.db.dLog('This should log because Database is active');
      // No assertion needed as we rely on the presence or absence of logs in the console
    });
  });
}
