import 'package:conversational_ai/ui/common/app_colors.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function() onSendMessage;
  final Function(String) onInputChanged;
  final Function()? onVoiceInput;
  final Function()? onStopVoiceInput;
  final String currentInput;
  final bool isLoading;
  final bool isListening;
  final bool isSpeechAvailable;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    required this.onInputChanged,
    this.onVoiceInput,
    this.onStopVoiceInput,
    required this.currentInput,
    required this.isLoading,
    this.isListening = false,
    this.isSpeechAvailable = false,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.currentInput;
  }

  @override
  void didUpdateWidget(ChatInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.text != widget.currentInput) {
      _controller.text = widget.currentInput;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_controller.text.trim().isNotEmpty && !widget.isLoading) {
      widget.onSendMessage();
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          // Text input field
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: widget.onInputChanged,
              onSubmitted: (_) => _handleSend(),
              enabled: !widget.isLoading && !widget.isListening,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText:
                    widget.isListening
                        ? 'Listening...'
                        : widget.isLoading
                        ? 'AI is thinking...'
                        : 'Type your message...',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Dynamic button (Voice or Send)
          if (widget.isSpeechAvailable) ...[
            // Voice button (when input is empty)
            if (_controller.text.trim().isEmpty)
              Container(
                decoration: BoxDecoration(
                  color: widget.isListening
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: widget.isListening
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: IconButton(
                  onPressed: widget.isLoading
                      ? null
                      : widget.isListening
                          ? widget.onStopVoiceInput
                          : widget.onVoiceInput,
                  icon: widget.isListening
                      ? const Icon(Icons.stop, color: AppColors.textLight)
                      : const Icon(Icons.mic, color: AppColors.textLight),
                  tooltip: widget.isListening ? 'Stop listening' : 'Tap to speak',
                ),
              )
            // Send button (when input has text)
            else
              Container(
                decoration: BoxDecoration(
                  color: widget.isLoading
                      ? AppColors.textSecondary
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: IconButton(
                  onPressed: widget.isLoading ? null : _handleSend,
                  icon: const Icon(Icons.send, color: AppColors.textLight),
                  tooltip: widget.isLoading ? 'AI is thinking...' : 'Send message',
                ),
              ),
          ],
        ],
      ),
    );
  }
}
