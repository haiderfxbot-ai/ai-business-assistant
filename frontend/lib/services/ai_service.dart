import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/ai_settings_model.dart';

class AIService {
  final _groqEndpoint = 'https://api.groq.com/openai/v1/chat/completions';
  final _geminiEndpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  Future<String> getReply(String message, AISettingsModel settings, {String? chatHistory}) async {
    try {
      if (settings.primaryMode == AIMode.cloud) {
        return await _getGroqReply(message, settings, chatHistory);
      }
      return await _getGeminiReply(message, settings, chatHistory);
    } catch (e) {
      try {
        return await _getGeminiReply(message, settings, chatHistory);
      } catch (e2) {
        return _getFallbackReply(message);
      }
    }
  }

  Future<String> _getGroqReply(String message, AISettingsModel settings, String? chatHistory) async {
    final response = await http.post(
      Uri.parse(_groqEndpoint),
      headers: {
        'Authorization': 'Bearer ${AppConfig.groqApiKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': AppConfig.groqModel,
        'messages': [
          {'role': 'system', 'content': _getSystemPrompt(settings)},
          if (chatHistory != null) ...[
            for (final msg in chatHistory.split('\n'))
              if (msg.isNotEmpty) ...{
                'role': 'user',
                'content': msg,
              }
          ],
          {'role': 'user', 'content': message},
        ],
        'temperature': 0.7,
        'max_tokens': settings.maxReplyLength,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] ?? '';
    }
    throw Exception('Groq API error: ${response.statusCode}');
  }

  Future<String> _getGeminiReply(String message, AISettingsModel settings, String? chatHistory) async {
    if (AppConfig.geminiApiKey.isEmpty) {
      return _getFallbackReply(message);
    }
    final url = '$_geminiEndpoint?key=${AppConfig.geminiApiKey}';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {'parts': [{'text': '${_getSystemPrompt(settings)}\n\nUser: $message'}], 'role': 'user'}
        ],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': settings.maxReplyLength,
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
    }
    throw Exception('Gemini API error: ${response.statusCode}');
  }

  String _getSystemPrompt(AISettingsModel settings) {
    final language = settings.enableUrduSupport
        ? 'You can reply in Urdu, English, or mix of both (Roman Urdu).'
        : 'Reply in English only.';
    return '''You are an AI business assistant for WhatsApp. 
Your tone should be ${settings.aiTone}.
Keep replies concise and professional.
$language
If the user asks about products, pricing, or orders, provide helpful business responses.
If you don't know specific business details, ask the user to provide them.''';
  }

  String _getFallbackReply(String message) {
    final replies = [
      'Thank you for your message. Our team will get back to you shortly.',
      'Thanks for reaching out! How can I help you today?',
      'I have received your message. Let me check and respond soon.',
      'Shukriya! Main aapki madad karta hoon. Kya aap apna sawaal likhenge?',
      'Thank you! Please share your details and we will assist you.',
    ];
    return replies[message.length % replies.length];
  }
}
