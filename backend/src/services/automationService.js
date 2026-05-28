const aiEngine = require('../ai/aiEngine');
const notificationService = require('./notificationService');

class AutomationService {
  async handleIncomingMessage(messageData) {
    const { from, body, chatId, userId } = messageData;

    // Process message through AI engine
    const aiResult = await aiEngine.processMessage(body);

    // Send notification to business owner
    await notificationService.sendAIResponseNotification(
      userId,
      from,
      aiResult.reply
    );

    return {
      reply: aiResult.reply,
      mode: aiResult.mode,
      complexity: aiResult.complexity,
    };
  }

  async processUnreadMessages(userId, messages) {
    const results = [];
    for (const msg of messages) {
      if (this.shouldAutoReply(msg)) {
        const result = await this.handleIncomingMessage({
          from: msg.from,
          body: msg.body,
          chatId: msg.chatId,
          userId,
        });
        results.push({ messageId: msg.id, ...result });
      }
    }
    return results;
  }

  shouldAutoReply(message) {
    // Don't auto-reply to already replied messages
    if (message.isReplied) return false;

    // Don't auto-reply to very short messages
    if (message.body?.length < 2) return false;

    return true;
  }

  async scheduleAutoReply(userId, chatId, delayMs = 5000) {
    return new Promise((resolve) => {
      setTimeout(async () => {
        const result = await this.handleIncomingMessage({
          from: chatId,
          body: 'Auto-triggered: Follow up',
          chatId,
          userId,
        });
        resolve(result);
      }, delayMs);
    });
  }
}

module.exports = new AutomationService();
