const { db } = require('../config/firebase');
const { v4: uuidv4 } = require('uuid');

const COLLECTION = 'orders';

class Order {
  static async create(data) {
    const order = {
      id: uuidv4(),
      customerId: data.customerId,
      customerName: data.customerName,
      items: data.items || [],
      totalAmount: data.totalAmount || 0,
      status: 'pending',
      invoiceURL: data.invoiceURL || null,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      notes: data.notes || null,
    };
    await db.collection(COLLECTION).doc(order.id).set(order);
    return order;
  }

  static async get(orderId) {
    const doc = await db.collection(COLLECTION).doc(orderId).get();
    return doc.exists ? { id: doc.id, ...doc.data() } : null;
  }

  static async getByCustomer(customerId) {
    const snap = await db.collection(COLLECTION)
      .where('customerId', '==', customerId)
      .orderBy('createdAt', 'desc')
      .limit(50)
      .get();
    return snap.docs.map(d => ({ id: d.id, ...d.data() }));
  }

  static async updateStatus(orderId, status) {
    await db.collection(COLLECTION).doc(orderId).update({
      status,
      updatedAt: new Date().toISOString(),
    });
  }

  static async getAnalytics(userId) {
    const snap = await db.collection(COLLECTION).get();
    const orders = snap.docs.map(d => d.data());
    return {
      total: orders.length,
      completed: orders.filter(o => o.status === 'delivered').length,
      pending: orders.filter(o => o.status === 'pending').length,
      totalRevenue: orders.reduce((sum, o) => sum + (o.totalAmount || 0), 0),
    };
  }
}

module.exports = Order;
