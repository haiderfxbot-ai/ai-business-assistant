import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/voice_service.dart';
import '../../services/ai_service.dart';
import '../../models/ai_settings_model.dart';

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
  final VoiceService _voiceService = VoiceService();
  final AIService _aiService = AIService();
  String _recognizedText = '';
  String _aiResponse = '';
  bool _isListening = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _voiceService.initialize();
  }

  Future<void> _startListening() async {
    setState(() { _isListening = true; _recognizedText = ''; _aiResponse = ''; });
    final text = await _voiceService.startListening();
    setState(() {
      _recognizedText = text;
      _isListening = false;
      _isProcessing = true;
    });
    if (text.isNotEmpty) {
      final response = await _aiService.getReply(text, AISettingsModel());
      setState(() { _aiResponse = response; _isProcessing = false; });
    } else {
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Assistant')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ask me anything', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 48),
              GestureDetector(
                onTap: _isListening ? null : _startListening,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isListening ? 160 : 120,
                  height: _isListening ? 160 : 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isListening ? AppTheme.secondaryColor : AppTheme.primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: (_isListening ? AppTheme.secondaryColor : AppTheme.primaryColor).withOpacity(0.4),
                        blurRadius: _isListening ? 40 : 20,
                        spreadRadius: _isListening ? 10 : 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _isListening ? 'Listening...' : 'Tap to speak',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              if (_isProcessing) ...[
                const SizedBox(height: 24),
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                const Text('AI is thinking...'),
              ],
              if (_recognizedText.isNotEmpty) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('You said:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(_recognizedText),
                      ],
                    ),
                  ),
                ),
              ],
              if (_aiResponse.isNotEmpty) ...[
                const SizedBox(height: 12),
                Card(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('AI Response:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(_aiResponse),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
