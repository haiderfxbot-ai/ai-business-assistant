const router = require('express').Router();
const aiEngine = require('../ai/aiEngine');
const { authenticate } = require('../middleware/auth');

router.post('/reply', authenticate, async (req, res) => {
  try {
    const { message, options } = req.body;
    if (!message) return res.status(400).json({ error: 'Message is required' });

    const result = await aiEngine.processMessage(message, options);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/process', authenticate, async (req, res) => {
  try {
    const { message, chatHistory, options } = req.body;
    if (!message) return res.status(400).json({ error: 'Message is required' });

    // If chat history provided, use it for context
    const context = chatHistory ? `Previous conversation:\n${chatHistory}\n\n` : '';
    const fullMessage = context + message;

    const result = await aiEngine.processMessage(fullMessage, options);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/classify', authenticate, async (req, res) => {
  try {
    const { message } = req.body;
    if (!message) return res.status(400).json({ error: 'Message is required' });

    const complexity = aiEngine._classify(message);
    res.json({ complexity, message: `Message classified as: ${complexity}` });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
