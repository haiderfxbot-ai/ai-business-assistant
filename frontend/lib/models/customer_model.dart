class CustomerModel {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? email;
  final String? whatsappId;
  final int totalOrders;
  final double totalSpent;
  final String? lastMessage;
  final DateTime? lastContact;
  final bool isFavorite;
  final List<String> tags;
  final Map<String, dynamic> customFields;
  final DateTime createdAt;

  CustomerModel({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    this.whatsappId,
    this.totalOrders = 0,
    this.totalSpent = 0.0,
    this.lastMessage,
    this.lastContact,
    this.isFavorite = false,
    this.tags = const [],
    this.customFields = const {},
    required this.createdAt,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      whatsappId: map['whatsappId'],
      totalOrders: map['totalOrders'] ?? 0,
      totalSpent: (map['totalSpent'] ?? 0).toDouble(),
      lastMessage: map['lastMessage'],
      lastContact: map['lastContact'] != null ? (map['lastContact'] as dynamic).toDate() : null,
      isFavorite: map['isFavorite'] ?? false,
      tags: List<String>.from(map['tags'] ?? []),
      customFields: Map<String, dynamic>.from(map['customFields'] ?? {}),
      createdAt: (map['createdAt'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'whatsappId': whatsappId,
      'totalOrders': totalOrders,
      'totalSpent': totalSpent,
      'lastMessage': lastMessage,
      'lastContact': lastContact,
      'isFavorite': isFavorite,
      'tags': tags,
      'customFields': customFields,
      'createdAt': createdAt,
    };
  }
}
