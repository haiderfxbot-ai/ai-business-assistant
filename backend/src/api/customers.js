const router = require('express').Router();
const { db } = require('../config/firebase');
const { authenticate } = require('../middleware/auth');
const { v4: uuidv4 } = require('uuid');

const COLLECTION = 'customers';

router.get('/', authenticate, async (req, res) => {
  try {
    const snap = await db.collection(COLLECTION)
      .where('userId', '==', req.user.uid)
      .orderBy('createdAt', 'desc')
      .get();
    const customers = snap.docs.map(d => ({ id: d.id, ...d.data() }));
    res.json(customers);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/', authenticate, async (req, res) => {
  try {
    const customer = {
      id: uuidv4(),
      userId: req.user.uid,
      name: req.body.name,
      phoneNumber: req.body.phoneNumber || null,
      email: req.body.email || null,
      whatsappId: req.body.whatsappId || null,
      totalOrders: 0,
      totalSpent: 0,
      isFavorite: false,
      tags: req.body.tags || [],
      customFields: req.body.customFields || {},
      createdAt: new Date().toISOString(),
    };
    await db.collection(COLLECTION).doc(customer.id).set(customer);
    res.status(201).json(customer);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/:customerId', authenticate, async (req, res) => {
  try {
    const doc = await db.collection(COLLECTION).doc(req.params.customerId).get();
    if (!doc.exists) return res.status(404).json({ error: 'Customer not found' });
    res.json({ id: doc.id, ...doc.data() });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.put('/:customerId', authenticate, async (req, res) => {
  try {
    await db.collection(COLLECTION).doc(req.params.customerId).update({
      ...req.body,
      updatedAt: new Date().toISOString(),
    });
    res.json({ message: 'Customer updated' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
