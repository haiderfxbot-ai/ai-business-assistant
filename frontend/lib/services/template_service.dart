import '../models/ai_settings_model.dart';

class TemplateService {
  final List<ReplyTemplate> _templates = [];

  void loadTemplates(List<ReplyTemplate> templates) {
    _templates.clear();
    _templates.addAll(templates);
  }

  String? matchTemplate(String message) {
    final lower = message.toLowerCase();
    for (final template in _templates) {
      if (!template.isActive) continue;
      if (lower.contains(template.triggerKeyword.toLowerCase())) {
        return template.replyText;
      }
    }
    return null;
  }

  bool hasTemplateMatch(String message) {
    return matchTemplate(message) != null;
  }

  String getDefaultTemplateReply(String message) {
    final greetings = ['hello', 'hi', 'assalamoalaikum', 'salam', 'hey', 'good morning', 'good evening'];
    final pricing = ['price', 'cost', 'kitne ka', 'rate', 'qimmat'];
    final contact = ['contact', 'phone', 'number', 'call', 'address', 'location'];
    final hours = ['time', 'khula', 'open', 'close', 'band', 'timing'];

    if (greetings.any((g) => message.toLowerCase().contains(g))) {
      return 'Assalam-o-Alaikum! Welcome to our business. How can I help you today?\n'
          'Please let me know your query and I will assist you.\n'
          'آپ کا استقبال ہے! آج میں آپ کی کیا مدد کر سکتا ہوں؟';
    }
    if (pricing.any((p) => message.toLowerCase().contains(p))) {
      return 'Thank you for your interest! Please share which product/service you are looking for, '
          'and I will share the pricing details with you.\n'
          'برائے مہربانی بتائیں کہ آپ کو کس پروڈکٹ کی قیمت چاہیے۔';
    }
    if (contact.any((c) => message.toLowerCase().contains(c))) {
      return 'You can contact us at our business number. Please share your query and we will assist you.\n'
          'آپ ہم سے رابطہ کر سکتے ہیں۔ برائے مہربانی اپنا سوال لکھیں۔';
    }
    if (hours.any((h) => message.toLowerCase().contains(h))) {
      return 'Our business hours are:\nMonday - Saturday: 10:00 AM - 8:00 PM\nSunday: Closed\n'
          'ہمارے اوقات کار: پیر تا ہفتہ صبح 10 سے شام 8 بجے تک';
    }
    return '';
  }
}
