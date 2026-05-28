enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final String customerId;
  final String customerName;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final String? invoiceURL;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.items,
    required this.totalAmount,
    this.status = OrderStatus.pending,
    this.invoiceURL,
    required this.createdAt,
    this.updatedAt,
    this.notes,
  });

  double get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  String get statusText => status.name.toUpperCase();

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      items: (map['items'] as List?)?.map((e) => OrderItem.fromMap(e)).toList() ?? [],
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      invoiceURL: map['invoiceURL'],
      createdAt: (map['createdAt'] as dynamic).toDate(),
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as dynamic).toDate() : null,
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status.name,
      'invoiceURL': invoiceURL,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'notes': notes,
    };
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  double get total => price * quantity;

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] ?? '',
      quantity: (map['quantity'] ?? 1) as int,
      price: (map['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'quantity': quantity, 'price': price};
  }
}
