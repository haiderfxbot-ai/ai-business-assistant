import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/chat_bubble.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          if (chatProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (chatProvider.chats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('No chats yet', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Text('Messages from WhatsApp will appear here', style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: chatProvider.chats.length,
            itemBuilder: (_, i) {
              final chat = chatProvider.chats[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.secondaryColor,
                  child: Text(chat['name'][0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                ),
                title: Text(chat['name'] ?? 'Unknown'),
                subtitle: Text(chat['lastMessage'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Text(chat['time'] ?? '', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => ChatScreen(chatId: chat['id'], chatName: chat['name']),
                )),
              );
            },
          );
        },
      ),
    );
  }
}
