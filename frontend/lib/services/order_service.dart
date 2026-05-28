import 'package:uuid/uuid.dart';
import '../models/order_model.dart';
import 'firestore_service.dart';

class OrderService {
  final FirestoreService _firestoreService = FirestoreService();
  final Uuid _uuid = const Uuid();

  Future<OrderModel> createOrder({
    required String customerId,
    required String customerName,
    required List<OrderItem> items,
    String? notes,
  }) async {
    final order = OrderModel(
      id: _uuid.v4(),
      customerId: customerId,
      customerName: customerName,
      items: items,
      totalAmount: items.fold(0.0, (sum, item) => sum + item.total),
      createdAt: DateTime.now(),
      notes: notes,
    );
    await _firestoreService.createOrder(order);
    return order;
  }

  Future<String> generateInvoice(OrderModel order) async {
    // Generate simple invoice text
    final buffer = StringBuffer();
    buffer.writeln('INVOICE');
    buffer.writeln('=======');
    buffer.writeln('Order #: ${order.id.substring(0, 8)}');
    buffer.writeln('Customer: ${order.customerName}');
    buffer.writeln('Date: ${order.createdAt.toIso8601String()}');
    buffer.writeln('-------');
    for (final item in order.items) {
      buffer.writeln('${item.name} x${item.quantity} - \u20B9${item.total.toStringAsFixed(2)}');
    }
    buffer.writeln('-------');
    buffer.writeln('Total: \u20B9${order.totalAmount.toStringAsFixed(2)}');
    buffer.writeln('Status: ${order.statusText}');
    return buffer.toString();
  }
}
