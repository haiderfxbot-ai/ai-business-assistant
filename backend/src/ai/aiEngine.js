const templateMatcher = require('./templateMatcher');
const localAI = require('./localAI');
const cloudAI = require('./cloudAI');

class AIEngine {
  async processMessage(message, options = {}) {
    const {
      enableTemplates = true,
      enableLocalAI = true,
      enableCloudAI = true,
      tone = 'professional',
      urduSupport = true,
    } = options;

    // Step 1: Classify message complexity
    const complexity = this._classify(message);

    // Step 2: Try Template (Level 1)
    if (enableTemplates) {
      const templateReply = templateMatcher.match(message);
      if (templateReply) {
        return {
          reply: templateReply.response,
          type: templateReply.type,
          complexity: 'simple',
          mode: 'template',
        };
      }
    }

    // Step 3: Try Local AI (Level 2)
    if (enableLocalAI) {
      const localReply = localAI.getReply(message);
      if (localReply) {
        return {
          reply: localReply,
          complexity: 'medium',
          mode: 'local',
        };
      }
    }

    // Step 4: Try Cloud AI (Level 3)
    if (enableCloudAI && complexity === 'complex') {
      try {
        const cloudReply = await cloudAI.getReply(message, { tone, urduSupport });
        if (cloudReply) {
          return {
            reply: cloudReply,
            complexity: 'complex',
            mode: 'cloud',
          };
        }
      } catch (e) {
        console.error('Cloud AI failed:', e.message);
      }
    }

    // Step 5: Ultimate fallback
    return {
      reply: this._getFallbackReply(message),
      complexity: 'fallback',
      mode: 'fallback',
    };
  }

  _classify(message) {
    const lower = message.toLowerCase().trim();
    if (templateMatcher.isSimpleQuery(message)) return 'simple';
    if (localAI.canHandle(message)) return 'medium';
    return 'complex';
  }

  _getFallbackReply(message) {
    const lower = message.toLowerCase();
    if (lower.includes('?') && lower.length > 20) {
      return 'Thank you for your detailed question. Our team will review and get back to you with a complete answer. Is there anything else I can help you with?\nآپ کے سوال کا شکریہ۔ ہماری ٹیم جلد جواب دے گی۔ کیا اور کچھ مدد چاہیے؟';
    }
    return 'Thank you for your message. I have noted your query and our team will assist you shortly. For immediate assistance, please call our business number.\nآپ کے پیغام کا شکریہ۔ ہماری ٹیم جلد آپ سے رابطہ کرے گی۔';
  }
}

module.exports = new AIEngine();
