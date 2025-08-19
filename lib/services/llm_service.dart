abstract class LlmService {
  /// Sends a message to the LLM and returns a stream of the response
  Stream<String> sendMessage(String message);

  /// Sends a message and returns the complete response
  Future<String> sendMessageComplete(String message);

  /// Gets the service name for identification
  String get serviceName;
}
