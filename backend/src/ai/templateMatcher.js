class TemplateMatcher {
  constructor() {
    this.templates = [];
    this.defaultResponses = {
      greeting: {
        keywords: ['hello', 'hi', 'assalamoalaikum', 'salam', 'hey', 'good morning', 'good evening', 'good afternoon'],
        response: 'Assalam-o-Alaikum! Welcome to our business. How can I help you today?',
        urdu: 'السلام علیکم! ہماری کاروبار میں خوش آمدید۔ میں آج آپ کی کیا مدد کر سکتا ہوں؟',
      },
      pricing: {
        keywords: ['price', 'cost', 'rate', 'qimmat', 'kitne ka', 'kitne ki', 'daam', 'value'],
        response: 'Thank you for your interest! Please share which product/service you are looking for, and I will share the pricing details.',
        urdu: 'آپ کی دلچسپی کا شکریہ! برائے مہربانی بتائیں کہ آپ کو کس پروڈکٹ کی قیمت چاہیے۔',
      },
      contact: {
        keywords: ['contact', 'phone', 'number', 'call', 'address', 'location', 'kahan ho'],
        response: 'Please share your query and we will assist you. You can also visit our business location during working hours.',
        urdu: 'برائے مہربانی اپنا سوال لکھیں۔ آپ کام کے اوقات میں ہم سے مل سکتے ہیں۔',
      },
      hours: {
        keywords: ['time', 'khula', 'open', 'close', 'band', 'timing', 'hour', 'kab khulta'],
        response: 'Our business hours: Monday - Saturday: 10:00 AM - 8:00 PM, Sunday: Closed',
        urdu: 'ہمارے اوقات کار: پیر تا ہفتہ صبح 10 سے شام 8 بجے تک، اتوار: بند',
      },
      thanks: {
        keywords: ['thank', 'thanks', 'shukriya', 'thankyou', 'thank you'],
        response: 'You are welcome! If you need any further assistance, feel free to ask.',
        urdu: 'آپ کا شکریہ! اگر مزید مدد درکار ہو تو ضرور پوچھیں۔',
      },
    };
  }

  loadTemplates(templates) {
    this.templates = templates || [];
  }

  match(message) {
    const lower = message.toLowerCase().trim();

    // Check custom templates first
    for (const template of this.templates) {
      if (!template.isActive) continue;
      if (lower.includes(template.triggerKeyword.toLowerCase())) {
        return { type: 'template', response: template.replyText };
      }
    }

    // Check default responses
    for (const [category, config] of Object.entries(this.defaultResponses)) {
      for (const keyword of config.keywords) {
        if (lower.includes(keyword)) {
          return { type: 'default', response: config.response, category };
        }
      }
    }

    return null;
  }

  isSimpleQuery(message) {
    const lower = message.toLowerCase().trim();
    const simpleIndicators = [
      ...this.defaultResponses.greeting.keywords,
      ...this.defaultResponses.pricing.keywords,
      ...this.defaultResponses.contact.keywords,
      ...this.defaultResponses.hours.keywords,
      ...this.defaultResponses.thanks.keywords,
    ];
    return simpleIndicators.some(k => lower.includes(k)) && lower.length < 30;
  }
}

module.exports = new TemplateMatcher();
