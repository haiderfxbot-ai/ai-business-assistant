import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import '../services/firestore_service.dart';

class CustomerProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final List<CustomerModel> _customers = [];
  bool _isLoading = false;

  List<CustomerModel> get customers => _customers;
  bool get isLoading => _isLoading;

  Future<void> loadCustomers(String userId) async {
    _isLoading = true;
    notifyListeners();
    _firestoreService.getCustomers(userId).listen((snap) {
      _customers.clear();
      _customers.addAll(snap.docs.map((d) => CustomerModel.fromMap(d.data())));
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addCustomer(CustomerModel customer) async {
    await _firestoreService.saveCustomer(customer);
    _customers.add(customer);
    notifyListeners();
  }
}
