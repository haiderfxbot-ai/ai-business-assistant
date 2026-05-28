import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/firestore_service.dart';

class ChatProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final List<Map<String, String>> _chats = [];
  final Map<String, List<MessageModel>> _messages = {};
  bool _isLoading = false;

  List<Map<String, String>> get chats => _chats;
  bool get isLoading => _isLoading;

  List<MessageModel> getMessages(String chatId) {
    return _messages[chatId] ?? [];
  }

  Future<void> sendMessage(String chatId, String text) async {
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      senderId: 'user',
      text: text,
      isAI: false,
      timestamp: DateTime.now(),
    );
    _messages.putIfAbsent(chatId, () => []).insert(0, message);
    await _firestoreService.saveMessage(message);
    notifyListeners();
  }

  void addAIMessage(String chatId, String text, String replyType) {
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      senderId: 'ai',
      text: text,
      isAI: true,
      replyType: replyType,
      timestamp: DateTime.now(),
    );
    _messages.putIfAbsent(chatId, () => []).insert(0, message);
    notifyListeners();
  }
}
