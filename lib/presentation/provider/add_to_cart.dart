import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:order_tracking/data/models/cart_model.dart';

class AddToCart extends ChangeNotifier {
  Map<String, List<CartItem>> _cartByTableId = {}; // Cart grouped by tableId

  // Get cart items for a specific table
  List<CartItem> getCartItems(String tableId) {
    return _cartByTableId[tableId] ?? [];
  }

  // Add an item to the cart for a specific table
  void addItem(String tableId, CartItem item) {
    if (_cartByTableId[tableId] == null) {
      _cartByTableId[tableId] = [];
    }
    _cartByTableId[tableId]!.add(item);
    notifyListeners();
    _saveCartToPrefs();
  }

  // Delete an item from the cart for a specific table
  void deletItem(String tableId, int index) {
    _cartByTableId[tableId]?.removeAt(index);
    notifyListeners();
    _saveCartToPrefs();
  }

  // Clear the cart for a specific table or all tables
  void clearCart([String? tableId]) {
    if (tableId != null) {
      // Clear cart for a specific table
      _cartByTableId.remove(tableId);
    } else {
      // Clear cart for all tables
      _cartByTableId.clear();
    }
    notifyListeners();
    _saveCartToPrefs();
  }

  // Increment the quantity of a specific item in the cart for a specific table
  void incrementQuantity(String tableId, int index) {
    if (_cartByTableId[tableId] != null && index >= 0 && index < _cartByTableId[tableId]!.length) {
      // Parse the current quantity
      int currentQuantity = int.tryParse(_cartByTableId[tableId]![index].quantity ?? "0") ?? 0;
      // Increment the quantity
      currentQuantity++;
      // Update the quantity in the cart item
      _cartByTableId[tableId]![index].quantity = currentQuantity.toString();
      notifyListeners();
      _saveCartToPrefs();
    }
  }

  // Decrement the quantity of a specific item in the cart for a specific table
  void decrementQuantity(String tableId, int index) {
    if (_cartByTableId[tableId] != null && index >= 0 && index < _cartByTableId[tableId]!.length) {
      // Parse the current quantity
      int currentQuantity = int.tryParse(_cartByTableId[tableId]![index].quantity ?? "0") ?? 0;
      // Decrement the quantity (but ensure it doesn't go below 1)
      if (currentQuantity > 1) {
        currentQuantity--;
        // Update the quantity in the cart item
        _cartByTableId[tableId]![index].quantity = currentQuantity.toString();
        notifyListeners();
        _saveCartToPrefs();
      }
    }
  }

  // Calculate the subtotal of all items in the cart for a specific table
  double getSubtotal(String tableId) {
    double subTotal = 0.0;
    for (var item in _cartByTableId[tableId] ?? []) {
      int quantity = int.tryParse(item.quantity ?? "0") ?? 0;
      double rate = item.rate ?? 0.0;
      subTotal += rate * quantity;
    }
    return subTotal;
  }

  // Save cart data to SharedPreferences
  Future<void> _saveCartToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> cartItemsJsonByTable = _cartByTableId.map((key, items) {
      return MapEntry(key, jsonEncode(items.map((item) => item.toJson()).toList()));
    });
    await prefs.setString('cartByTableId', jsonEncode(cartItemsJsonByTable));
  }

  // Load cart data from SharedPreferences
  Future<void> loadCartFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartItemsJsonByTable = prefs.getString('cartByTableId');
    if (cartItemsJsonByTable != null) {
      Map<String, dynamic> decodedCartData = jsonDecode(cartItemsJsonByTable);
      _cartByTableId = decodedCartData.map((key, value) {
        List<CartItem> items = (jsonDecode(value) as List)
            .map((itemJson) => CartItem.fromJson(itemJson))
            .toList();
        return MapEntry(key, items);
      });
      notifyListeners();
    }
  }
}