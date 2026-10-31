import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Speech-to-Text service for voice questions.
class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;

  bool get isListening => _isListening;
  bool get isAvailable => _isInitialized;

  /// Initialize microphone speech engine safely.
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _speech.initialize(
        onError: (val) {
          debugPrint('SpeechService error: $val');
          _isListening = false;
        },
        onStatus: (val) {
          debugPrint('SpeechService status: $val');
          if (val == 'done' || val == 'notListening') {
            _isListening = false;
          }
        },
      );
      return _isInitialized;
    } catch (e) {
      debugPrint('SpeechService initialization failed: $e');
      _isInitialized = false;
      return false;
    }
  }

  /// Start listening and stream transcribed words.
  Future<void> startListening({
    required Function(String recognizedWords) onResult,
    String localeId = 'en_US',
  }) async {
    if (!_isInitialized) {
      final ready = await initialize();
      if (!ready) {
        onResult('Microphone service is getting ready. You can also type your question.');
        return;
      }
    }

    try {
      _isListening = true;
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
      );
    } catch (e) {
      debugPrint('SpeechService listen error: $e');
      _isListening = false;
    }
  }

  /// Stop listening.
  Future<void> stopListening() async {
    try {
      if (_isListening) {
        await _speech.stop();
        _isListening = false;
      }
    } catch (e) {
      debugPrint('SpeechService stop error: $e');
    }
  }
}
