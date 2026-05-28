import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/chat_provider.dart';
import '../../providers/ai_provider.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/message_input.dart';
import '../../widgets/ai_suggestion_bar.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String chatName;

  const ChatScreen({super.key, required this.chatId, required this.chatName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.secondaryColor,
              child: Text(chatName[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chatName, style: const TextStyle(fontSize: 16)),
                Text('AI Active', style: TextStyle(fontSize: 11, color: Colors.green[300])),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, _) {
                final messages = chatProvider.getMessages(chatId);
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (_, i) => ChatBubble(message: messages[i]),
                );
              },
            ),
          ),
          const AISuggestionBar(),
          MessageInput(chatId: chatId),
        ],
      ),
    );
  }
}
