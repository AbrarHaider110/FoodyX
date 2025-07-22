import 'package:flutter/material.dart';

class Order {
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;

  Order({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });
}

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void removeOrder(Order order) {
    _orders.remove(order);
    notifyListeners();
  }
}
