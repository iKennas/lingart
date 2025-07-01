// lib/services/audio_service.dart
class AudioService {
  // Placeholder methods to prevent errors
  static Future<void> playAudio(String audioUrl) async {
    print('Audio playback not implemented: $audioUrl');
  }

  static Future<bool> initializeSpeechRecognition() async {
    print('Speech recognition not implemented');
    return false;
  }

  static Future<void> startListening({
    required Function(String) onResult,
    Function(String)? onError,
  }) async {
    print('Speech listening not implemented');
    // Call onResult with empty string to prevent hanging
    onResult('');
  }

  static Future<void> stopListening() async {
    print('Stop listening not implemented');
  }

  static double calculateAccuracy(String expected, String actual) {
    print('Accuracy calculation not implemented');
    return 0.0;
  }
}