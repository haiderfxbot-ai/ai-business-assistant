const axios = require('axios');
const config = require('../config/config');

class CloudAI {
  async getGroqReply(message, options = {}) {
    const { tone = 'professional', urduSupport = true, maxTokens = 500 } = options;

    const language = urduSupport
      ? 'You can reply in Urdu, English, or Roman Urdu (Urdu written in English script).'
      : 'Reply in English only.';

    try {
      const response = await axios.post(config.groq.endpoint, {
        model: config.groq.model,
        messages: [
          {
            role: 'system',
            content: `You are an AI business assistant for WhatsApp. Your tone should be ${tone}. Keep replies concise and professional. ${language} If the user asks about products, pricing, or orders, provide helpful business responses. If you don't know specific business details, ask the user to provide them.`,
          },
          { role: 'user', content: message },
        ],
        temperature: config.groq.temperature,
        max_tokens: maxTokens,
      }, {
        headers: {
          Authorization: `Bearer ${config.groq.apiKey}`,
          'Content-Type': 'application/json',
        },
      });

      return response.data.choices[0].message.content;
    } catch (error) {
      console.error('Groq API error:', error.message);
      throw error;
    }
  }

  async getGeminiReply(message, options = {}) {
    const { tone = 'professional', urduSupport = true, maxTokens = 500 } = options;

    if (!config.gemini.apiKey) {
      throw new Error('Gemini API key not configured');
    }

    const language = urduSupport
      ? 'You can reply in Urdu, English, or Roman Urdu.'
      : 'Reply in English only.';

    try {
      const url = `${config.gemini.endpoint}?key=${config.gemini.apiKey}`;
      const response = await axios.post(url, {
        contents: [{
          parts: [{
            text: `You are an AI business assistant for WhatsApp. Tone: ${tone}. ${language}\n\nUser: ${message}`,
          }],
        }],
        generationConfig: {
          temperature: 0.7,
          maxOutputTokens: maxTokens,
        },
      });

      return response.data.candidates?.[0]?.content?.parts?.[0]?.text || '';
    } catch (error) {
      console.error('Gemini API error:', error.message);
      throw error;
    }
  }

  async getReply(message, options = {}) {
    // Try Groq first, fallback to Gemini
    try {
      if (config.groq.apiKey) {
        return await this.getGroqReply(message, options);
      }
    } catch (e) {
      console.log('Groq failed, trying Gemini');
    }

    try {
      if (config.gemini.apiKey) {
        return await this.getGeminiReply(message, options);
      }
    } catch (e) {
      console.log('Gemini failed too');
    }

    return null;
  }
}

module.exports = new CloudAI();
