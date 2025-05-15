// Example of using nested decorators with custom providers
/*

final customTokenProvider = MyCustomTokenProvider();
final customUserAccessProvider = MyCustomUserAccessProvider();

// Create base client
final baseClient = DioHttpClient();

// Add basic auth
final basicAuthClient = BasicHTTPClientDecorator(baseClient);

// Add token and platform info
final authClient = AuthHTTPClientDecorator(
  basicAuthClient,
  tokenProvider: customTokenProvider,
);

// Add user permissions
final userPermissionsClient = UserPermissionsHTTPClientDecorator(
  authClient,
  userAccessProvider: customUserAccessProvider,
  accessLevel: UserAccessLevel.all,
);

// Use the fully decorated client
final response = await userPermissionsClient.request(...);


*/
