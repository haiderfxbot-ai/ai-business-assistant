const { messaging } = require('../config/firebase');

class NotificationService {
  async sendToUser(uid, title, body, data = {}) {
    try {
      await messaging.send({
        topic: `user_${uid}`,
        notification: { title, body },
        data,
        android: {
          priority: 'high',
          notification: {
            channelId: 'ai_channel',
            priority: 'high',
            defaultSound: true,
          },
        },
        apns: {
          payload: {
            aps: { sound: 'default', badge: 1 },
          },
        },
      });
    } catch (error) {
      console.error('Notification error:', error);
    }
  }

  async sendToDevice(token, title, body, data = {}) {
    try {
      await messaging.send({
        token,
        notification: { title, body },
        data,
        android: { priority: 'high' },
      });
    } catch (error) {
      console.error('Device notification error:', error);
    }
  }

  async sendAIResponseNotification(uid, customerName, response) {
    await this.sendToUser(uid, `AI replied to ${customerName}`,
      response.substring(0, 100),
      { type: 'ai_response', customerName, fullResponse: response }
    );
  }

  async sendNewOrderNotification(uid, orderId, customerName) {
    await this.sendToUser(uid, 'New Order Received',
      `Order from ${customerName}`,
      { type: 'new_order', orderId, customerName }
    );
  }
}

module.exports = new NotificationService();
