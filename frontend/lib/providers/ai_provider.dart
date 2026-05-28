import 'package:flutter/material.dart';
import '../models/ai_settings_model.dart';
import '../services/ai_service.dart';
import '../services/template_service.dart';

class AIProvider extends ChangeNotifier {
  final AIService _aiService = AIService();
  final TemplateService _templateService = TemplateService();
  bool _isGenerating = false;
  AISettingsModel _settings = AISettingsModel();

  bool get isGenerating => _isGenerating;
  AISettingsModel get settings => _settings;

  void updateSettings(AISettingsModel settings) {
    _settings = settings;
    _templateService.loadTemplates(settings.templates);
    notifyListeners();
  }

  Future<String> generateReply(String chatId, String message) async {
    _isGenerating = true;
    notifyListeners();

    try {
      // Level 1: Template match
      if (_settings.primaryMode == AIMode.template || _settings.primaryMode == AIMode.local) {
        final templateReply = _templateService.matchTemplate(message);
        if (templateReply != null) {
          _isGenerating = false;
          notifyListeners();
          return templateReply;
        }
      }

      // Level 2: Local / Cloud AI
      String reply;
      if (_settings.primaryMode == AIMode.local) {
        reply = await _aiService.getReply(message, _settings);
      } else {
        reply = await _aiService.getReply(message, _settings);
      }

      _isGenerating = false;
      notifyListeners();
      return reply;
    } catch (e) {
      // Fallback
      final fallback = _templateService.getDefaultTemplateReply(message);
      _isGenerating = false;
      notifyListeners();
      return fallback.isNotEmpty ? fallback : 'Thank you for your message. I will get back to you shortly.';
    }
  }

  String classifyMessage(String message) {
    final lower = message.toLowerCase();
    if (lower.length < 20 && (lower.contains('?') || lower.length < 10)) return 'simple';
    if (lower.length < 100 && !lower.contains(RegExp(r'https?://'))) return 'medium';
    return 'complex';
  }
}
