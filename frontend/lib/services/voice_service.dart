import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;

  bool get isListening => _isListening;
  bool get isAvailable => _speech.isAvailable;

  Future<bool> initialize() async {
    final available = await _speech.initialize();
    return available;
  }

  Future<String> startListening({Duration? timeout}) async {
    _isListening = true;
    String recognizedText = '';
    await _speech.listen(
      onResult: (result) {
        recognizedText = result.recognizedWords;
      },
      listenFor: timeout ?? const Duration(seconds: 30),
      localeId: 'ur_PK',
    );
    _isListening = false;
    return recognizedText;
  }

  Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
  }

  void dispose() {
    _speech.stop();
  }
}
