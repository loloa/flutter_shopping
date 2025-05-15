import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/app_logger.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/views/new_item.dart';
import 'package:http_module/src.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _items = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGroceryItems();
  }

  void _loadGroceryItems() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final List<GroceryItemDTO> groceryDTOs =
          await GroceryApi.getGroceryItems();

      final List<GroceryItem> loadedItems =
          groceryDTOs.map((dto) {
            final itemCategory = categories.values.firstWhere(
              (category) => category.title == dto.category,
            );

            return GroceryItem(
              id: dto.dbId!,
              name: dto.name!,
              quantity: dto.quantity!,
              category: itemCategory,
            );
          }).toList();

      setState(() {
        _items = loadedItems;
        _isLoading = false;
      });

      AppLog.api.info('LOADED ${loadedItems.length} items');
    } catch (e) {
      setState(() {
        _error = 'Failed to load items.\nTry again later';
        _isLoading = false;
      });
      AppLog.api.error('Error loading grocery items: $e');
    }
  }

  void _addNewitem() async {
    final justAddedItem = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const NewItem()));
    if (justAddedItem == null) {
      return;
    }
    setState(() {
      _items.add(justAddedItem);
    });
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _items.remove(item);
    });
  }

  static const _emptyStateMessage = Center(
    child: Text(
      'Your list is empty...\nUse \' + \' to add a new item.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 147, 229, 250)),
    ),
  );

  static const _loadingView = Center(
    child: SizedBox(width: 44, height: 44, child: CircularProgressIndicator()),
  );

  Widget _errorMessageView() {
    var center = Center(
      child: Text(
        _error!,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          color: Color.fromARGB(255, 147, 229, 250),
        ),
      ),
    );
    return center;
  }

  Widget _buildListItem(GroceryItem item) {
    return Dismissible(
      key: ValueKey(item.id),
      onDismissed: (direction) {
        _removeItem(item);
      },
      background: Container(
        color: Colors.red,
        margin: Theme.of(context).cardTheme.margin,
      ),
      child: ListTile(
        leading: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: item.category.color),
        ),
        title: Text(item.name),
        trailing: Text(item.quantity.toString()),
      ),
    );
  }

  Widget _buildcontent() {
    if (_error != null) {
      return _errorMessageView();
    }
    if (_isLoading) {
      return _loadingView;
    }
    if (_items.isEmpty) {
      return _emptyStateMessage;
    }
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) => _buildListItem(_items[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: _addNewitem, icon: Icon(Icons.add))],
      ),

      body: _buildcontent(),
    );
  }
}
