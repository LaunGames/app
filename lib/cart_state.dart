import 'package:flutter/material.dart';

class CartItem {
  final String title;
  final String price;
  int quantity;

  CartItem({required this.title, required this.price, this.quantity = 1});
}

class CartState extends ChangeNotifier {
  final List<CartItem> items = [];

  void addItem(String title, String price) {
    final existing = items.indexWhere((i) => i.title == title);
    if (existing >= 0) {
      items[existing].quantity++;
    } else {
      items.add(CartItem(title: title, price: price));
    }
    notifyListeners();
  }

  void removeItem(String title) {
    items.removeWhere((i) => i.title == title);
    notifyListeners();
  }

  void clear() {
    items.clear();
    notifyListeners();
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  int get totalPrice => items.fold(0, (sum, item) => sum + (int.parse(item.price) * item.quantity));
}