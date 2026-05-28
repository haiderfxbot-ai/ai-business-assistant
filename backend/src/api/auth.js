const router = require('express').Router();
const { auth } = require('../config/firebase');
const User = require('../models/User');

router.post('/register', async (req, res) => {
  try {
    const { uid, email, displayName } = req.body;
    if (!uid) return res.status(400).json({ error: 'UID required' });
    await User.create(uid, { email, displayName });
    res.status(201).json({ message: 'User created', uid });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/profile/:uid', async (req, res) => {
  try {
    const user = await User.get(req.params.uid);
    if (!user) return res.status(404).json({ error: 'User not found' });
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.put('/profile/:uid', async (req, res) => {
  try {
    await User.update(req.params.uid, req.body);
    res.json({ message: 'Profile updated' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.delete('/:uid', async (req, res) => {
  try {
    await User.delete(req.params.uid);
    await auth.deleteUser(req.params.uid);
    res.json({ message: 'User deleted' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
