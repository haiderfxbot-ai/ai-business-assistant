const router = require('express').Router();
const Message = require('../models/Message');
const { authenticate } = require('../middleware/auth');

router.get('/:chatId', authenticate, async (req, res) => {
  try {
    const messages = await Message.getByChat(req.params.chatId);
    res.json(messages);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/', authenticate, async (req, res) => {
  try {
    const message = await Message.create(req.body);
    res.status(201).json(message);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.put('/:chatId/:messageId/read', authenticate, async (req, res) => {
  try {
    await Message.markAsRead(req.params.chatId, req.params.messageId);
    res.json({ message: 'Marked as read' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
