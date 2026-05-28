import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _fcm.requestPermission();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _localNotifications.initialize(const InitializationSettings(android: androidSettings, iOS: iosSettings));

    final token = await _fcm.getToken();
    if (token != null) {
      _saveToken(token);
    }

    _fcm.onTokenRefresh.listen(_saveToken);
    FirebaseMessaging.onMessage.listen(_handleMessage);
  }

  void _saveToken(String token) {
    // Save FCM token to Firestore for the user
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails('ai_channel', 'AI Business Assistant',
            importance: Importance.high, priority: Priority.high,
            showWhen: true, enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
  }

  Future<String?> getToken() => _fcm.getToken();

  Future<void> showQuickReplyNotification({
    required String title,
    required String body,
    required String action,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'quick_reply', 'Quick Replies',
      importance: Importance.high,
      priority: Priority.high,
      actions: [
        AndroidNotificationAction('reply', 'Reply'),
        AndroidNotificationAction('ignore', 'Ignore'),
      ],
    );
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch,
      title,
      body,
      NotificationDetails(android: androidDetails),
    );
  }
}
