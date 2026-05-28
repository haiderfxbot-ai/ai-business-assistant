module.exports = {
  port: process.env.PORT || 3000,
  nodeEnv: process.env.NODE_ENV || 'development',
  groq: {
    apiKey: process.env.GROQ_API_KEY || '',
    model: 'llama3-70b-8192',
    endpoint: 'https://api.groq.com/openai/v1/chat/completions',
    maxTokens: 500,
    temperature: 0.7,
  },
  gemini: {
    apiKey: process.env.GEMINI_API_KEY || '',
    model: 'gemini-1.5-flash',
    endpoint: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent',
  },
  jwt: {
    secret: process.env.JWT_SECRET || 'ai-business-assistant-secret',
    expiresIn: '7d',
  },
  ai: {
    enableTemplates: true,
    enableLocalAI: true,
    enableCloudAI: true,
    maxReplyLength: 500,
    defaultTone: 'professional',
  },
};
