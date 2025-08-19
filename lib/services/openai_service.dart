import 'dart:async';

import 'package:conversational_ai/services/llm_service.dart';

class OpenAiService implements LlmService {
  // static const String _apiKey = String.fromEnvironment('OPENAI_API_KEY');
  // static const String _baseUrl = 'https://api.openai.com/v1';

  @override
  String get serviceName => 'OpenAI Service';

  @override
  Stream<String> sendMessage(String message) async* {
    yield 'OpenAI service not yet implemented. Please use MockLlmService for now.';
  }

  @override
  Future<String> sendMessageComplete(String message) async {
    return 'OpenAI service not yet implemented. Please use MockLlmService for now.';
  }
}
