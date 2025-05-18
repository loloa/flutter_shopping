import 'package:flutter/material.dart';
import 'package:http_module/src.dart';

class ApiErrorManager {
  static final ApiErrorManager _instance = ApiErrorManager._internal();
  bool _isShowingDialog = false;
  bool _isShowingSnackbar = false;

  factory ApiErrorManager() => _instance;

  ApiErrorManager._internal();

  /// Handles API errors consistently across the app
  Future<bool> handleApiError(
    BuildContext context,
    dynamic error, {
    VoidCallback? onRetry,
  }) async {
    if (error is! ApiError) return false;

    switch (error.behavior) {
      case ApiErrorBehavior.showMessage:
        if (_isShowingSnackbar) return true;
        _showErrorMessage(context, error);
        return true;

      case ApiErrorBehavior.requestCode:
        if (_isShowingDialog) return true;

        _isShowingDialog = true;
        final code = await _showAuthCodeDialog(context);
        _isShowingDialog = false;

        if (code != null && code.isNotEmpty && onRetry != null) {
          // Set auth code in your auth service here if needed
          onRetry();
        }
        return true;

      case ApiErrorBehavior.ignore:
        // Just log it, don't show UI
        return true;
    }
  }

  void _showErrorMessage(BuildContext context, ApiError error) {
    final message =
        error.statusCode == 403
            ? 'Access forbidden. You don\'t have permission.'
            : error.message;

    _isShowingSnackbar = true;

    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(message),
            onVisible: () => _isShowingSnackbar = true,
            dismissDirection: DismissDirection.down,
          ),
        )
        .closed
        .then((_) => _isShowingSnackbar = false);
  }

  Future<String?> _showAuthCodeDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Authentication Required'),
            content: TextField(
              decoration: const InputDecoration(labelText: 'Enter access code'),
              onSubmitted: (value) => Navigator.of(ctx).pop(value),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(null),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final controller =
                      ModalRoute.of(ctx)!.settings.arguments
                          as TextEditingController?;
                  Navigator.of(ctx).pop(controller?.text);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
    );
  }
}
