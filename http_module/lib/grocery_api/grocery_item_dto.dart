class GroceryItemDTO {
  String? dbId;
  String? category;
  String? name;
  int? quantity;

  GroceryItemDTO({this.dbId, this.category, this.name, this.quantity});

  GroceryItemDTO.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    name = json['name'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['category'] = category;
    data['name'] = name;
    data['quantity'] = quantity;
    return data;
  }
}
