import 'package:flutter/material.dart';

class OrderItem {
  final String id;
  final String title;
  final String price;
  final String status;

  OrderItem({required this.id, required this.title, required this.price, required this.status});
}

class OrdersState extends ChangeNotifier {
  final List<OrderItem> orders = [];
  int _nextId = 1001;

  void addOrder(List<String> titles, List<String> prices) {
    for (int i = 0; i < titles.length; i++) {
      orders.add(OrderItem(
        id: '#${_nextId++}',
        title: titles[i],
        price: prices[i],
        status: 'Готовится',
      ));
    }
    notifyListeners();
  }
}