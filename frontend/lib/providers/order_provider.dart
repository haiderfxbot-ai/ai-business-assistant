import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/firestore_service.dart';

class OrderProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> loadOrders(String userId) async {
    _isLoading = true;
    notifyListeners();
    _firestoreService.getOrders(userId).listen((snap) {
      _orders.clear();
      _orders.addAll(snap.docs.map((d) => OrderModel.fromMap(d.data())));
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> createOrder(OrderModel order) async {
    await _firestoreService.createOrder(order);
    _orders.insert(0, order);
    notifyListeners();
  }

  Future<void> updateStatus(String orderId, OrderStatus status) async {
    await _firestoreService.updateOrderStatus(orderId, status);
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      _orders[idx] = OrderModel(
        id: _orders[idx].id,
        customerId: _orders[idx].customerId,
        customerName: _orders[idx].customerName,
        items: _orders[idx].items,
        totalAmount: _orders[idx].totalAmount,
        status: status,
        createdAt: _orders[idx].createdAt,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }
}
