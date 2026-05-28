const { db } = require('../config/firebase');

class Message {
  static async create(data) {
    const msg = {
      chatId: data.chatId,
      senderId: data.senderId,
      text: data.text,
      replyType: data.replyType || 'manual',
      isAI: data.isAI || false,
      isRead: false,
      timestamp: new Date().toISOString(),
      metadata: data.metadata || {},
    };
    const ref = await db.collection('chats').doc(data.chatId).collection('messages').add(msg);
    return { id: ref.id, ...msg };
  }

  static async getByChat(chatId, limit = 50) {
    const snap = await db.collection('chats').doc(chatId)
      .collection('messages')
      .orderBy('timestamp', 'desc')
      .limit(limit)
      .get();
    return snap.docs.map(d => ({ id: d.id, ...d.data() }));
  }

  static async markAsRead(chatId, messageId) {
    await db.collection('chats').doc(chatId)
      .collection('messages').doc(messageId)
      .update({ isRead: true });
  }
}

module.exports = Message;
