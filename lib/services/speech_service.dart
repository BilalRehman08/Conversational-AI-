import 'dart:async';
import 'dart:math';

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  bool _isListening = false;
  bool _isInitialized = true; // Mock initialization

  bool get isListening => _isListening;
  bool get isAvailable => _isInitialized;

  // Mock speech responses for demonstration
  static const List<String> _mockSpeechResponses = [
    "Hello, how are you today?",
    "What's the weather like?",
    "Tell me a joke",
    "What time is it?",
    "How do I make coffee?",
    "What's the capital of France?",
    "Can you help me with my homework?",
    "What's the meaning of life?",
    "How do I cook pasta?",
    "What's the latest news?",
  ];

  /// Initialize the speech recognition service (mock)
  Future<bool> initialize() async {
    // Simulate initialization delay
    await Future.delayed(Duration(milliseconds: 500));
    _isInitialized = true;
    return true;
  }

  /// Start listening for speech input (mock)
  Future<void> startListening({
    required Function(String text) onResult,
    required Function() onListeningComplete,
  }) async {
    if (_isListening) return;

    try {
      _isListening = true;

      // Simulate listening delay (shorter for better UX)
      await Future.delayed(Duration(seconds: 1 + Random().nextInt(2)));

      // Generate a random mock response
      final randomResponse =
          _mockSpeechResponses[Random().nextInt(_mockSpeechResponses.length)];

      // Simulate speech recognition with a slight delay
      await Future.delayed(Duration(milliseconds: 300));

      onResult(randomResponse);
      _isListening = false;
      onListeningComplete();
    } catch (e) {
      _isListening = false;
      throw Exception('Error starting speech recognition: $e');
    }
  }

  /// Stop listening for speech input (mock)
  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      await Future.delayed(Duration(milliseconds: 300));
      _isListening = false;
    } catch (e) {
      print('Error stopping speech recognition: $e');
    }
  }

  /// Check if speech recognition is available on the device (mock)
  Future<bool> checkAvailability() async {
    return _isInitialized;
  }
}
