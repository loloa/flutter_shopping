import 'api_error_behavior.dart';

// Map of endpoint patterns to error behaviors
final Map<EndpointKey, Map<int, ApiErrorBehavior>> errorBehaviorMap = {
  // Example: POST to authentication endpoints shows code popup for 403
  EndpointKey('auth/', 'POST'): {403: ApiErrorBehavior.requestCode},
  // Example: Product endpoints show message for 403
  EndpointKey('products/', 'GET'): {403: ApiErrorBehavior.showMessage},
  // Default behavior
  EndpointKey('', ''): {403: ApiErrorBehavior.showMessage},
};

class EndpointKey {
  final String path;
  final String method;

  const EndpointKey(this.path, this.method);

  @override
  bool operator ==(Object other) =>
      other is EndpointKey && path == other.path && method == other.method;

  @override
  int get hashCode => Object.hash(path, method);
}
