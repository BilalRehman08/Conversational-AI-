import 'dart:convert';
import 'dart:io';

import 'package:conversational_ai/models/conversation_log.dart';

class LoggingService {
  static const String _logFileName = 'conversation_logs.json';

  List<ConversationLog> _logs = [];

  List<ConversationLog> get logs => List.unmodifiable(_logs);

  /// Logs a conversation exchange
  Future<void> logConversation(String userMessage, String aiResponse) async {
    final log = ConversationLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userMessage: userMessage,
      aiResponse: aiResponse,
      timestamp: DateTime.now(),
    );

    _logs.add(log);
    await _saveLogs();
  }

  /// Loads logs from local storage
  Future<void> loadLogs() async {
    try {
      final file = File(_getLogFilePath());
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        _logs = jsonList.map((json) => ConversationLog.fromJson(json)).toList();
      }
    } catch (e) {
      // If there's an error loading logs, start with empty list
      _logs = [];
    }
  }

  /// Saves logs to local storage
  Future<void> _saveLogs() async {
    try {
      final file = File(_getLogFilePath());
      final jsonString = json.encode(_logs.map((log) => log.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      // Handle save error - could add error reporting here
      print('Error saving logs: $e');
    }
  }

  /// Clears all logs
  Future<void> clearLogs() async {
    _logs.clear();
    await _saveLogs();
  }

  String _getLogFilePath() {
    // For now, using a simple path. In production, you might want to use
    // getApplicationDocumentsDirectory() from path_provider package
    return 'logs/$_logFileName';
  }
}
