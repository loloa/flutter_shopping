import 'package:http_module/app_info.dart';

enum GroceryAPIEndPoints {
  get,
  post;

  Uri url({String? base}) {
    final baseUrl = base ?? AppInfo.appBaseURL;
    switch (this) {
      case GroceryAPIEndPoints.get:
        return Uri.https(baseUrl, 'shopping-list.json');
      case GroceryAPIEndPoints.post:
        return Uri.https(baseUrl, 'shopping-list.json');
    }
  }
}
