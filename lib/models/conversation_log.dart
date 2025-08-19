class ConversationLog {
  final String id;
  final String userMessage;
  final String aiResponse;
  final DateTime timestamp;

  ConversationLog({
    required this.id,
    required this.userMessage,
    required this.aiResponse,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userMessage': userMessage,
      'aiResponse': aiResponse,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ConversationLog.fromJson(Map<String, dynamic> json) {
    return ConversationLog(
      id: json['id'],
      userMessage: json['userMessage'],
      aiResponse: json['aiResponse'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
