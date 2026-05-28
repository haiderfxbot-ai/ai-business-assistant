class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final String replyType;
  final bool isAI;
  final bool isRead;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    this.replyType = 'manual',
    this.isAI = false,
    this.isRead = false,
    required this.timestamp,
    this.metadata,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      replyType: map['replyType'] ?? 'manual',
      isAI: map['isAI'] ?? false,
      isRead: map['isRead'] ?? false,
      timestamp: (map['timestamp'] as dynamic).toDate(),
      metadata: map['metadata'] != null ? Map<String, dynamic>.from(map['metadata']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'replyType': replyType,
      'isAI': isAI,
      'isRead': isRead,
      'timestamp': timestamp,
      'metadata': metadata,
    };
  }

  bool get isFromCustomer => !isAI;
  bool get isFromAI => isAI;
}
