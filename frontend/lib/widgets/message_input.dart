import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/ai_provider.dart';

class MessageInput extends StatefulWidget {
  final String chatId;

  const MessageInput({super.key, required this.chatId});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    setState(() => _isComposing = false);

    final chatProvider = context.read<ChatProvider>();
    final aiProvider = context.read<AIProvider>();

    await chatProvider.sendMessage(widget.chatId, text);
    await aiProvider.generateReply(widget.chatId, text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {},
              color: Colors.grey[600],
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: (v) => setState(() => _isComposing = v.isNotEmpty),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                maxLines: 4,
                minLines: 1,
              ),
            ),
            const SizedBox(width: 4),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: _isComposing
                ? FloatingActionButton.small(
                    key: const ValueKey('send'),
                    onPressed: _sendMessage,
                    child: const Icon(Icons.send, size: 18),
                  )
                : FloatingActionButton.small(
                    key: const ValueKey('mic'),
                    onPressed: () {},
                    child: const Icon(Icons.mic, size: 18),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
