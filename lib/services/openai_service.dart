import 'dart:async';

import 'package:conversational_ai/services/config_service.dart';
import 'package:conversational_ai/services/llm_service.dart';

class OpenAiService implements LlmService {
  final apiKey = ConfigService.openaiApiKey;
  final baseUrl = ConfigService.openaiBaseUrl;

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
