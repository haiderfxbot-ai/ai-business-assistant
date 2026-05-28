import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import '../models/order_model.dart';
import '../models/customer_model.dart';
import '../models/ai_settings_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Messages
  Future<void> saveMessage(MessageModel message) async {
    await _db.collection('chats').doc(message.chatId).collection('messages').doc(message.id).set(message.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatId) {
    return _db.collection('chats').doc(chatId).collection('messages').orderBy('timestamp', descending: true).snapshots();
  }

  Future<List<MessageModel>> getChatHistory(String chatId) async {
    final snap = await _db.collection('chats').doc(chatId).collection('messages').orderBy('timestamp', descending: true).limit(50).get();
    return snap.docs.map((d) => MessageModel.fromMap(d.data())).toList();
  }

  // Orders
  Future<void> createOrder(OrderModel order) async {
    await _db.collection('orders').doc(order.id).set(order.toMap());
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _db.collection('orders').doc(orderId).update({'status': status.name, 'updatedAt': DateTime.now()});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrders(String userId) {
    return _db.collection('orders').where('customerId', isEqualTo: userId).orderBy('createdAt', descending: true).snapshots();
  }

  // Customers
  Future<void> saveCustomer(CustomerModel customer) async {
    await _db.collection('customers').doc(customer.id).set(customer.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCustomers(String userId) {
    return _db.collection('customers').where('userId', isEqualTo: userId).snapshots();
  }

  Future<CustomerModel?> getCustomer(String customerId) async {
    final doc = await _db.collection('customers').doc(customerId).get();
    if (!doc.exists) return null;
    return CustomerModel.fromMap(doc.data()!);
  }

  // AI Settings
  Future<void> saveAISettings(String userId, AISettingsModel settings) async {
    await _db.collection('users').doc(userId).update({'aiSettings': settings.toMap()});
  }

  Future<AISettingsModel?> getAISettings(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    if (data['aiSettings'] == null) return null;
    return AISettingsModel.fromMap(Map<String, dynamic>.from(data['aiSettings']));
  }

  // Analytics
  Future<Map<String, dynamic>> getAnalytics(String userId) async {
    final ordersSnap = await _db.collection('orders').where('customerId', isEqualTo: userId).get();
    final customersSnap = await _db.collection('customers').where('userId', isEqualTo: userId).get();
    final totalOrders = ordersSnap.docs.length;
    final totalRevenue = ordersSnap.docs.fold(0.0, (sum, doc) => sum + (doc.data()['totalAmount'] ?? 0));
    final totalCustomers = customersSnap.docs.length;
    return {
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'totalCustomers': totalCustomers,
      'completedOrders': ordersSnap.docs.where((d) => d.data()['status'] == 'delivered').length,
    };
  }
}
