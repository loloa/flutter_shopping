import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GroceryCell extends StatelessWidget {
  const GroceryCell({super.key, required this.model});

  final GroceryItem model;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: model.category.color),
        ),
        SizedBox(width: 20),
        Expanded(child: Text(model.name)),
        SizedBox(),
        Text('${model.quantity}'),
      ],
    );
  }
}
