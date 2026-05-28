const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');

admin.initializeApp();

const db = admin.firestore();

// Auto-reply when new message is created
exports.onNewMessage = functions.firestore
  .document('chats/{chatId}/messages/{messageId}')
  .onCreate(async (snap, context) => {
    const message = snap.data();
    if (message.isAI) return null; // Don't reply to AI messages

    try {
      const chatRef = db.collection('chats').doc(context.params.chatId);
      const chatDoc = await chatRef.get();
      if (!chatDoc.exists) return null;

      const userId = chatDoc.data()?.userId;
      if (!userId) return null;

      // Get user's AI settings
      const userDoc = await db.collection('users').doc(userId).get();
      const settings = userDoc.data()?.settings || {};

      // Call backend AI engine
      const response = await axios.post(
        'https://ai-business-assistant.onrender.com/api/ai/reply',
        { message: message.text, options: settings },
        { headers: { 'Content-Type': 'application/json' }}
      );

      Auto-reply with AI response
      const aiReply = response.data?.reply;
      if (aiReply) {
        await db.collection('chats').doc(context.params.chatId)
          .collection('messages').add({
            chatId: context.params.chatId,
            senderId: 'ai',
            text: aiReply,
            replyType: response.data?.mode || 'ai',
            isAI: true,
            isRead: false,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            metadata: { mode: response.data?.mode, complexity: response.data?.complexity },
          });
      }
    } catch (error) {
      console.error('Auto-reply error:', error);
    }
  });

// Send notification on new order
exports.onNewOrder = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async (snap) => {
    const order = snap.data();
    const userDoc = await db.collection('users').doc(order.customerId).get();
    const user = userDoc.data();

    if (user?.fcmToken) {
      await admin.messaging().send({
        token: user.fcmToken,
        notification: {
          title: 'New Order',
          body: `Order from ${order.customerName} - $${order.totalAmount}`,
        },
        data: { orderId: order.id, type: 'new_order' },
      });
    }
  });

// Daily analytics summary (scheduled)
exports.dailyAnalytics = functions.pubsub
  .schedule('0 9 * * *')
  .onRun(async () => {
    const users = await db.collection('users').get();
    for (const userDoc of users.docs) {
      const userId = userDoc.id;
      const ordersSnap = await db.collection('orders')
        .where('customerId', '==', userId)
        .where('createdAt', '>=', new Date(Date.now() - 24 * 60 * 60 * 1000))
        .get();

      if (ordersSnap.size > 0 && userDoc.data()?.fcmToken) {
        await admin.messaging().send({
          token: userDoc.data().fcmToken,
          notification: {
            title: 'Daily Analytics',
            body: `You received ${ordersSnap.size} orders yesterday!`,
          },
          data: { type: 'daily_analytics', orders: ordersSnap.size.toString() },
        });
      }
    }
  });
