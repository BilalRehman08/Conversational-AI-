import 'dart:async';
import 'dart:math';

import 'package:conversational_ai/services/llm_service.dart';

class MockLlmService implements LlmService {
  static const List<String> _mockResponses = [
    "That's an interesting question! Let me think about that for a moment...",
    "I understand what you're asking. Here's what I can tell you about that topic.",
    "Great question! Based on my knowledge, I'd say that...",
    "I'm not entirely sure about that, but I can share some general information.",
    "That's a complex topic. Let me break it down for you...",
    "I appreciate you asking that. Here's my perspective on the matter.",
    "That's something I've thought about before. Let me explain...",
    "Interesting point! I think there are several ways to look at this.",
    "I'm glad you brought that up. It's an important consideration.",
    "That's a good question that deserves a thoughtful response.",
  ];

  static const List<String> _greetingResponses = [
    "Hello! How can I help you today?",
    "Hi there! What would you like to know?",
    "Greetings! I'm here to assist you with any questions.",
    "Hello! I'm ready to help with whatever you need.",
    "Hi! What can I do for you today?",
  ];

  static const List<String> _farewellResponses = [
    "Goodbye! Feel free to ask if you need anything else.",
    "See you later! Have a great day!",
    "Take care! I'm here when you need me.",
    "Bye! Don't hesitate to reach out again.",
    "Farewell! It was nice chatting with you.",
  ];

  @override
  String get serviceName => 'Mock LLM Service';

  @override
  Stream<String> sendMessage(String message) async* {
    // Simulate thinking delay
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)));

    String response = _generateResponse(message);

    // Simulate streaming effect
    for (int i = 0; i < response.length; i++) {
      yield response.substring(0, i + 1);
      await Future.delayed(Duration(milliseconds: 20 + Random().nextInt(30)));
    }
  }

  @override
  Future<String> sendMessageComplete(String message) async {
    // Simulate thinking delay
    await Future.delayed(Duration(milliseconds: 1000 + Random().nextInt(1000)));
    return _generateResponse(message);
  }

  String _generateResponse(String message) {
    final lowerMessage = message.toLowerCase();
    final trimmedMessage = message.trim();

    // Check for very short messages
    if (trimmedMessage.length <= 3) {
      return "I see you typed '$trimmedMessage'. Could you tell me more about what you'd like to discuss?";
    }

    // Check for greetings
    if (_isGreeting(lowerMessage)) {
      return _greetingResponses[Random().nextInt(_greetingResponses.length)];
    }

    // Check for farewells
    if (_isFarewell(lowerMessage)) {
      return _farewellResponses[Random().nextInt(_farewellResponses.length)];
    }

    // Check for questions
    if (_isQuestion(lowerMessage)) {
      return _mockResponses[Random().nextInt(_mockResponses.length)];
    }

    // Default response for longer messages
    return "That's an interesting point about '$trimmedMessage'. Could you elaborate on what you mean?";
  }

  bool _isGreeting(String message) {
    final greetings = [
      'hello',
      'hi',
      'hey',
      'good morning',
      'good afternoon',
      'good evening',
    ];
    return greetings.any((greeting) => message.contains(greeting));
  }

  bool _isFarewell(String message) {
    final farewells = ['bye', 'goodbye', 'see you', 'farewell', 'take care'];
    return farewells.any((farewell) => message.contains(farewell));
  }

  bool _isQuestion(String message) {
    return message.contains('?') ||
        message.startsWith('what') ||
        message.startsWith('how') ||
        message.startsWith('why') ||
        message.startsWith('when') ||
        message.startsWith('where') ||
        message.startsWith('who') ||
        message.startsWith('can you') ||
        message.startsWith('could you');
  }
}
