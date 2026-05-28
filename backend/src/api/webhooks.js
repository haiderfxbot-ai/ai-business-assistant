const router = require('express').Router();
const aiEngine = require('../ai/aiEngine');
const { messaging } = require('../config/firebase');

// Webhook for receiving messages (for future WhatsApp Business API)
router.post('/whatsapp', async (req, res) => {
  try {
    const { from, body, timestamp } = req.body;

    // Process with AI
    const aiResult = await aiEngine.processMessage(body);

    // Send push notification to user
    if (aiResult.mode !== 'fallback') {
      await messaging.send({
        topic: `user_${from}`,
        notification: {
          title: 'New WhatsApp Message',
          body: `${body.substring(0, 50)}...`,
        },
        data: {
          from,
          aiResponse: aiResult.reply,
          mode: aiResult.mode,
          timestamp: timestamp || new Date().toISOString(),
        },
      });
    }

    // Respond to WhatsApp
    res.json({
      status: 'processed',
      aiResult: aiResult.mode,
      reply: aiResult.reply,
    });
  } catch (error) {
    console.error('Webhook error:', error);
    res.json({ status: 'error', message: error.message });
  }
});

// Meta WhatsApp Cloud API verification
router.get('/whatsapp', (req, res) => {
  const verifyToken = process.env.WHATSAPP_VERIFY_TOKEN || 'ai_business_assistant_verify_2026';
  const mode = req.query['hub.mode'];
  const token = req.query['hub.verify_token'];
  const challenge = req.query['hub.challenge'];

  if (mode === 'subscribe' && token === verifyToken) {
    console.log('Webhook verified');
    res.status(200).send(challenge);
  } else {
    res.sendStatus(403);
  }
});

// Generic webhook for custom integrations
router.post('/generic', async (req, res) => {
  try {
    const { source, data } = req.body;
    console.log(`Webhook received from: ${source}`, data);
    res.json({ received: true, timestamp: new Date().toISOString() });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
