import 'package:flutter/material.dart';
import 'package:shopping_list/app_logger.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/views/new_item.dart';
import 'package:http_module/src.dart';
import 'package:shopping_list/api_error_manager.dart';

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
      final handled = await ApiErrorManager().handleApiError(
        context,
        e,
        onRetry: _loadGroceryItems,
      );
      if (!mounted) return;
      if (!handled) {
        // Only set error state if not handled by manager
        setState(() {
          _error = 'Failed to load items.\nTry again later';
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
      AppLog.api.error('Error loading grocery items: ${e.toString()}');
    }
  }

  void _removeItem(GroceryItem item) async {
    final index = _items.indexOf(item);

    setState(() {
      _items.remove(item);
    });

    try {
      final removed = await GroceryApi.deleteGroceryItem(item.id);

      if (!removed) {
        _undo(index, item);
      }
    } catch (e) {
      AppLog.api.error('Error deleting item: $e');
      _undo(index, item);
    }
  }

  void _undo(int index, GroceryItem item) {
    AppLog.api.error('Error deleting item');
    setState(() {
      _items.insert(index, item);
    });
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

  Widget _emptyStateMessage() {
    var center = Center(
      child: Text(
        'Your list is empty...\nUse \' + \' to add a new item.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
    return center;
  }

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
          color: Theme.of(context).colorScheme.error,
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
      return _emptyStateMessage();
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
