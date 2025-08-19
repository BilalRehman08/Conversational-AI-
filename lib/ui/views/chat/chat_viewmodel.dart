import 'dart:async';

import 'package:conversational_ai/app/app.locator.dart';
import 'package:conversational_ai/models/chat_message.dart';
import 'package:conversational_ai/models/conversation_log.dart';
import 'package:conversational_ai/services/llm_service.dart';
import 'package:conversational_ai/services/logging_service.dart';
import 'package:conversational_ai/services/speech_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatViewModel extends BaseViewModel {
  final _llmService = locator<LlmService>();
  final _loggingService = locator<LoggingService>();
  final _speechService = locator<SpeechService>();
  final _snackbarService = locator<SnackbarService>();

  static const int _maxConversationHistory =
      10; // Show last 5 turns (10 messages)

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  List<ConversationLog> _logs = [];
  List<ConversationLog> get logs => List.unmodifiable(_logs);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _currentInput = '';
  String get currentInput => _currentInput;

  bool _showLogs = false;
  bool get showLogs => _showLogs;

  bool _isListening = false;
  bool get isListening => _isListening;

  bool _showVoiceSuccess = false;
  bool get showVoiceSuccess => _showVoiceSuccess;

  StreamSubscription<String>? _streamSubscription;

  ChatViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    setBusy(true);
    await _loggingService.loadLogs();
    _logs = _loggingService.logs;
    setBusy(false);
  }

  void updateInput(String value) {
    _currentInput = value;
    notifyListeners();
  }

  Future<void> sendMessage() async {
    if (_currentInput.trim().isEmpty) return;

    final userMessage = _currentInput.trim();
    _currentInput = '';
    notifyListeners();

    // Add user message with the actual user input
    final userMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    final userChatMessage = ChatMessage(
      id: userMessageId,
      content: userMessage,
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    _addMessage(userChatMessage);

    // Add small delay to ensure different timestamps
    await Future.delayed(Duration(milliseconds: 1));

    // Add AI message placeholder
    final aiMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    final aiChatMessage = ChatMessage(
      id: aiMessageId,
      content: '',
      type: MessageType.ai,
      timestamp: DateTime.now(),
      isStreaming: true,
    );
    _addMessage(aiChatMessage);
    _setLoading(true);

    try {
      // Get streaming response
      _streamSubscription = _llmService
          .sendMessage(userMessage)
          .listen(
            (chunk) {
              _updateStreamingMessage(aiMessageId, chunk);
            },
            onDone: () async {
              _finalizeStreamingMessage(aiMessageId);
              _setLoading(false);

              // Get the final message content for logging
              final finalMessage = _messages.firstWhere(
                (m) => m.id == aiMessageId,
              );
              await _loggingService.logConversation(
                userMessage,
                finalMessage.content,
              );
              _logs = _loggingService.logs;
              notifyListeners();
            },
            onError: (error) {
              _setLoading(false);
              _snackbarService.showSnackbar(
                message: 'Error: ${error.toString()}',
                duration: Duration(seconds: 3),
              );
            },
          );
    } catch (e) {
      _setLoading(false);
      _snackbarService.showSnackbar(
        message: 'Error sending message: ${e.toString()}',
        duration: Duration(seconds: 3),
      );
    }
  }

  void _addMessage(ChatMessage message) {
    _messages.add(message);

    // Keep only the last N messages
    if (_messages.length > _maxConversationHistory) {
      _messages = _messages.sublist(_messages.length - _maxConversationHistory);
    }

    notifyListeners();
  }

  void _updateStreamingMessage(String messageId, String content) {
    final index = _messages.indexWhere(
      (m) => m.id == messageId && m.type == MessageType.ai,
    );
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(content: content);
      notifyListeners();
    }
  }

  void _finalizeStreamingMessage(String messageId) {
    final index = _messages.indexWhere(
      (m) => m.id == messageId && m.type == MessageType.ai,
    );
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(isStreaming: false);
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void toggleLogs() {
    _showLogs = !_showLogs;
    notifyListeners();
  }

  Future<void> clearLogs() async {
    await _loggingService.clearLogs();
    _logs = [];
    notifyListeners();
  }

  /// Start voice input
  Future<void> startVoiceInput() async {
    if (_isListening) return;

    try {
      // Initialize speech service if needed
      final isAvailable = await _speechService.checkAvailability();
      if (!isAvailable) {
        // We'll handle this through UI feedback instead of snackbar
        return;
      }

      _isListening = true;
      notifyListeners();

      await _speechService.startListening(
        onResult: (text) {
          if (text.isNotEmpty) {
            _currentInput = text;
            _showVoiceSuccess = true;
            notifyListeners();
            // Hide success indicator after 2 seconds
            Future.delayed(Duration(seconds: 2), () {
              _showVoiceSuccess = false;
              notifyListeners();
            });
          }
        },
        onListeningComplete: () {
          _isListening = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _isListening = false;
      notifyListeners();
      // We'll handle errors through UI feedback instead of snackbar
      print('Speech recognition error: ${e.toString()}');
    }
  }

  /// Stop voice input
  Future<void> stopVoiceInput() async {
    if (!_isListening) return;

    try {
      await _speechService.stopListening();
      _isListening = false;
      notifyListeners();
      // We'll handle feedback through UI instead of snackbar
    } catch (e) {
      print('Error stopping speech recognition: ${e.toString()}');
    }
  }

  /// Check if speech recognition is available
  Future<bool> isSpeechAvailable() async {
    return await _speechService.checkAvailability();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _speechService.stopListening();
    super.dispose();
  }
}
