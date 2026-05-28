class AppConfig {
  static const String appName = 'AI Business Assistant';
  static const String version = '1.0.0';
  static const String backendUrl = 'https://ai-business-assistant.onrender.com';
  static const String groqApiKey = String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  static const String geminiModel = 'gemini-1.5-flash';
  static const String groqModel = 'llama3-70b-8192';

  static const bool enableLocalAI = true;
  static const bool enableCloudAI = true;
  static const bool enableTemplates = true;
  static const int maxOfflineReplies = 20;
  static const int maxCacheMessages = 500;
}
