import 'package:http_module/app_info.dart';

enum GroceryAPIEndPoints {
  get,
  post,
  delete;

  Uri url({String? base, String? itemId}) {
    final baseUrl = base ?? AppInfo.appBaseURL;
    switch (this) {
      case GroceryAPIEndPoints.get:
        return Uri.https(baseUrl, 'shopping-list.json');
      case GroceryAPIEndPoints.post:
        return Uri.https(baseUrl, 'shopping-list.json');
      case GroceryAPIEndPoints.delete:
        return Uri.https(baseUrl, 'shopping-list/$itemId.json');
    }
  }
}
