import 'package:http_module/API_services/grocery_api/grocery_endpoints.dart';
import 'package:http_module/API_services/grocery_api/grocery_item_dto.dart';
import 'package:http_module/client/client/dio_client.dart';
import 'package:http_module/client/abstract_client/http_client.dart';
//

class GroceryApi {
  static HttpClient _getClient() {
    // Use the basic HTTP client decorator with default authorization provider
    return DioHttpClient(); // HttpDotDartClient(); // DioHttpClient();
  }

  static Future<String?> addGroceryItem(Map<String, dynamic> body) async {
    final client = _getClient();
    final url = GroceryAPIEndPoints.post.url();
    final response = await client.request(
      url.toString(),
      HttpMethod.post,
      body: body,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return null;
    }
    final Map<String, dynamic> json = response.data;
    final identifier = json['name'];
    return identifier;
  }

  static Future<bool> deleteGroceryItem(String itemId) async {
    final client = _getClient();
    final url = GroceryAPIEndPoints.delete.url(itemId: itemId);
    final response = await client.request(url.toString(), HttpMethod.delete);
    return (response.statusCode >= 200 && response.statusCode < 300);
  }

  static Future<List<GroceryItemDTO>> getGroceryItems() async {
    final client = _getClient();
    final url = GroceryAPIEndPoints.get.url();

    final response = await client.request(url.toString(), HttpMethod.get);
    // Parse the response for map with ID keys
    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> dataMap = response.data;
      final List<GroceryItemDTO> items = [];

      dataMap.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          // Parse each item using the fromJson constructor
          final item = GroceryItemDTO.fromJson(value);
          item.dbId = key; // Set the database ID from the key
          items.add(item);
        }
      });

      return items;
    }
    return [];
  }
}
