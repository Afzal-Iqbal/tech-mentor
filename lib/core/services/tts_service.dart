import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Text-to-Speech service for patient spoken answers.
class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  TtsService() {
    _initTts();
  }

  void _initTts() {
    try {
      _flutterTts.setStartHandler(() {
        _isPlaying = true;
      });

      _flutterTts.setCompletionHandler(() {
        _isPlaying = false;
      });

      _flutterTts.setErrorHandler((msg) {
        debugPrint('TtsService error: $msg');
        _isPlaying = false;
      });

      _flutterTts.setSpeechRate(0.42); // Calm, deliberate, easy for older adults to follow
      _flutterTts.setVolume(1.0);
      _flutterTts.setPitch(1.0);
    } catch (e) {
      debugPrint('TtsService init exception: $e');
    }
  }

  /// Speak text aloud in the preferred language.
  Future<void> speak(String text, {String languageCode = 'en-US'}) async {
    if (text.trim().isEmpty) return;
    try {
      if (_isPlaying) {
        await stop();
      }

      if (languageCode == 'ur') {
        // Attempt Urdu locale, fallback to regional voice
        await _flutterTts.setLanguage('ur-PK');
      } else {
        await _flutterTts.setLanguage('en-US');
      }

      _isPlaying = true;
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('TtsService speak error: $e');
      _isPlaying = false;
    }
  }

  /// Stop current spoken voice.
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      _isPlaying = false;
    } catch (e) {
      debugPrint('TtsService stop error: $e');
    }
  }
}
