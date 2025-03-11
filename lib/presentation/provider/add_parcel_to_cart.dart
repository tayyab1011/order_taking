import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:order_tracking/data/models/cart_model.dart';

class AddParcelToCart extends ChangeNotifier {
  List<CartItem> _cartItems = []; // Single list for cart items

  List<CartItem> get cartItems => _cartItems;

  // Add an item to the cart
  void addItem(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
    _saveCartToPrefs();
  }

  // Delete an item from the cart
  void deleteItem(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
      _saveCartToPrefs();
    }
  }

  // Clear the entire cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
    _saveCartToPrefs();
  }

  // Get a copy of the cart items list
  List<CartItem> getCartItems() {
    return List.from(_cartItems);
  }

  // Increment the quantity of a specific item in the cart
  void incrementQuantity(int index) {
    if (index >= 0 && index < _cartItems.length) {
      // Parse the current quantity
      int currentQuantity = int.tryParse(_cartItems[index].quantity ?? "0") ?? 0;
      // Increment the quantity
      currentQuantity++;
      // Update the quantity in the cart item
      _cartItems[index].quantity = currentQuantity.toString();
      notifyListeners();
      _saveCartToPrefs();
    }
  }

  // Decrement the quantity of a specific item in the cart
  void decrementQuantity(int index) {
    if (index >= 0 && index < _cartItems.length) {
      // Parse the current quantity
      int currentQuantity = int.tryParse(_cartItems[index].quantity ?? "0") ?? 0;
      // Decrement the quantity (but ensure it doesn't go below 1)
      if (currentQuantity > 1) {
        currentQuantity--;
        // Update the quantity in the cart item
        _cartItems[index].quantity = currentQuantity.toString();
        notifyListeners();
        _saveCartToPrefs();
      }
    }
  }

  // Calculate the subtotal of all items in the cart
  double getSubtotal() {
    double subTotal = 0.0;
    for (var item in _cartItems) {
      int quantity = int.tryParse(item.quantity ?? "0") ?? 0;
      double rate = item.rate ?? 0.0;
      subTotal += rate * quantity;
    }
    return subTotal;
  }

  // Save cart data to SharedPreferences
  Future<void> _saveCartToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartItemsJson = jsonEncode(_cartItems.map((item) => item.toJson()).toList());
    await prefs.setString('cartItems', cartItemsJson);
  }

  // Load cart data from SharedPreferences
  Future<void> loadCartFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartItemsJson = prefs.getString('cartItems');
    if (cartItemsJson != null) {
      List<dynamic> decodedCartData = jsonDecode(cartItemsJson);
      _cartItems = decodedCartData.map((itemJson) => CartItem.fromJson(itemJson)).toList();
      notifyListeners();
    }
  }
}