enum ApiErrorBehavior { ignore, requestCode, showMessage }

class ApiError implements Exception {
  final int statusCode;
  final String message;
  final ApiErrorBehavior behavior;

  ApiError(this.statusCode, this.message, this.behavior);

  @override
  String toString() {
    return 'ApiError( behavior: $behavior, statusCode: $statusCode, message: $message)';
  }

  // // Factory for 403 errors with specific behavior
  // factory ApiError.forbidden({
  //   required ApiErrorBehavior behavior,
  //   String message = 'Access forbidden',
  // }) {
  //   return ApiError(403, message, behavior);
  // }
}
