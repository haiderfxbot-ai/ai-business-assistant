const router = require('express').Router();
const Order = require('../models/Order');
const { authenticate } = require('../middleware/auth');

router.get('/', authenticate, async (req, res) => {
  try {
    const orders = await Order.getByCustomer(req.user.uid);
    res.json(orders);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/', authenticate, async (req, res) => {
  try {
    const order = await Order.create({ ...req.body, customerId: req.user.uid });
    res.status(201).json(order);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/:orderId', authenticate, async (req, res) => {
  try {
    const order = await Order.get(req.params.orderId);
    if (!order) return res.status(404).json({ error: 'Order not found' });
    res.json(order);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.put('/:orderId/status', authenticate, async (req, res) => {
  try {
    const { status } = req.body;
    const validStatuses = ['pending', 'processing', 'shipped', 'delivered', 'cancelled'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({ error: 'Invalid status' });
    }
    await Order.updateStatus(req.params.orderId, status);
    res.json({ message: 'Status updated', status });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/analytics/summary', authenticate, async (req, res) => {
  try {
    const analytics = await Order.getAnalytics(req.user.uid);
    res.json(analytics);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
