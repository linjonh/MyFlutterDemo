import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:my_flutter_demo/log_print.dart';

class CartModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Item> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  /// The current total price of all items (assuming all items cost $42).
  int get totalPrice => _items.length * 42;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(Item item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}

class Item {
  String? name;
  int? value;
}

void testCartModel() {
  var cart = CartModel();
  cart.addListener(() {
    myLog("cart changed=${cart.items.length}");
  });
  cart.add(Item());
}
