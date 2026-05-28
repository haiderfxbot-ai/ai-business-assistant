// Local AI handler - runs simple rule-based responses locally
// For on-device: Gemma 2B / TinyLlama / Phi via MLC LLM
// This backend version provides smart rule-based fallback

class LocalAI {
  getReply(message, options = {}) {
    const lower = message.toLowerCase().trim();

    // Product inquiry
    if (lower.includes('product') || lower.includes('detail') || lower.includes('feature') || lower.includes('specification')) {
      return this._productReply(lower);
    }

    // Order inquiry
    if (lower.includes('order') || lower.includes('track') || lower.includes('delivery') || lower.includes('ship')) {
      return this._orderReply(lower);
    }

    // Payment inquiry
    if (lower.includes('payment') || lower.includes('pay') || lower.includes('mode') || lower.includes('transfer')) {
      return this._paymentReply(lower);
    }

    // General business inquiry
    if (lower.includes('service') || lower.includes('offer') || lower.includes('deal') || lower.includes('discount')) {
      return this._serviceReply(lower);
    }

    // Custom complicated - needs cloud AI
    return null;
  }

  canHandle(message) {
    const lower = message.toLowerCase();
    const localKeywords = ['product', 'detail', 'feature', 'order', 'track', 'delivery',
      'ship', 'payment', 'service', 'offer', 'deal', 'discount', 'warranty', 'return',
      'exchange', 'refund', 'quality', 'available', 'stock'];
    return localKeywords.some(k => lower.includes(k)) && lower.length < 150;
  }

  _productReply(message) {
    if (message.includes('available') || message.includes('stock')) {
      return 'Thank you for your interest! Our products are currently in stock. Please share which specific product you are looking for, and I will provide details about availability and pricing.\nآپ کی دلچسپی کا شکریہ! ہمارے پاس پروڈکٹس موجود ہیں۔ برائے مہربانی بتائیں کہ آپ کو کون سی پروڈکٹ چاہیے۔';
    }
    return 'Our products are high quality and competitively priced. Please let me know which product category you are interested in, and I will share detailed information with you.\nہماری پروڈکٹس اعلیٰ معیار کی ہیں۔ برائے مہربانی بتائیں کہ آپ کو کس قسم کی پروڈکٹ چاہیے۔';
  }

  _orderReply(message) {
    return 'To track your order, please share your order number. If you have not placed an order yet, I can help you with the ordering process.\nاپنے آرڈر کو ٹریک کرنے کیلئے برائے مہربانی اپنا آرڈر نمبر بتائیں۔';
  }

  _paymentReply(message) {
    return 'We accept multiple payment methods including bank transfer, EasyPaisa, JazzCash, and cash on delivery. Please let me know which method works best for you.\nہم مختلف طریقوں سے ادائیگی قبول کرتے ہیں۔';
  }

  _serviceReply(message) {
    return 'We offer a variety of services. Please share your requirements and I will provide you with the best options available.\nہم مختلف خدمات پیش کرتے ہیں۔ برائے مہربانی اپنی ضروریات بتائیں۔';
  }
}

module.exports = new LocalAI();
