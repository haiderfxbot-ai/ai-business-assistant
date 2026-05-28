import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static const platform = MethodChannel('com.aibusiness.assistant/whatsapp');

  Future<bool> sendMessage(String phoneNumber, String message) async {
    final url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      return true;
    }
    return false;
  }

  Future<String?> readLastMessage() async {
    try {
      final result = await platform.invokeMethod('getLastWhatsAppMessage');
      return result as String?;
    } on PlatformException catch (_) {
      return null;
    }
  }

  Future<bool> startAccessibilityService() async {
    try {
      final result = await platform.invokeMethod('startAccessibilityService');
      return result as bool;
    } on PlatformException catch (_) {
      return false;
    }
  }

  Future<bool> sendAutoReply(String phoneNumber, String message) async {
    try {
      final result = await platform.invokeMethod('sendAutoReply', {
        'phone': phoneNumber,
        'message': message,
      });
      return result as bool;
    } on PlatformException catch (_) {
      return false;
    }
  }
}
