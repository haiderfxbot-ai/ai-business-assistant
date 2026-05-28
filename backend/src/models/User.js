const { db } = require('../config/firebase');

const COLLECTION = 'users';

class User {
  static async create(uid, data) {
    await db.collection(COLLECTION).doc(uid).set({
      uid,
      email: data.email || null,
      displayName: data.displayName || null,
      phoneNumber: data.phoneNumber || null,
      photoURL: data.photoURL || null,
      businessName: data.businessName || null,
      isPremium: false,
      createdAt: new Date().toISOString(),
      lastLogin: new Date().toISOString(),
      settings: {
        autoReply: true,
        urduSupport: true,
        aiMode: 'local',
        aiTone: 'professional',
      },
    });
  }

  static async get(uid) {
    const doc = await db.collection(COLLECTION).doc(uid).get();
    return doc.exists ? { id: doc.id, ...doc.data() } : null;
  }

  static async update(uid, data) {
    await db.collection(COLLECTION).doc(uid).update({
      ...data,
      updatedAt: new Date().toISOString(),
    });
  }

  static async delete(uid) {
    await db.collection(COLLECTION).doc(uid).delete();
  }

  static async getAISettings(uid) {
    const user = await this.get(uid);
    return user?.settings || {};
  }

  static async updateAISettings(uid, settings) {
    await db.collection(COLLECTION).doc(uid).update({
      settings,
      updatedAt: new Date().toISOString(),
    });
  }
}

module.exports = User;
