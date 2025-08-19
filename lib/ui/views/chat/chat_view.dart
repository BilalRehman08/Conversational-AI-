import 'package:conversational_ai/services/config_service.dart';
import 'package:conversational_ai/ui/common/app_colors.dart';
import 'package:conversational_ai/ui/views/chat/chat_viewmodel.dart';
import 'package:conversational_ai/ui/widgets/chat_bubble.dart';
import 'package:conversational_ai/ui/widgets/chat_input.dart';
import 'package:conversational_ai/ui/widgets/recent_conversations_sheet.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ChatView extends StackedView<ChatViewModel> {
  const ChatView({super.key});

  @override
  Widget builder(BuildContext context, ChatViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Conversational AI',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: AppColors.textPrimary),
            onPressed:
                () => RecentConversationsSheet.show(context, viewModel.logs),
            tooltip: 'View Recent Conversations',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat messages area
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: AppColors.background),
                child:
                    viewModel.isBusy
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                        : viewModel.messages.isEmpty
                        ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Start a conversation!',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: viewModel.messages.length,
                          itemBuilder: (context, index) {
                            final message = viewModel.messages[index];
                            return ChatBubble(message: message);
                          },
                        ),
              ),
            ),
            // Voice input indicator
            if (viewModel.isListening)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                color: AppColors.primary.withOpacity(0.1),
                child: Row(
                  children: [
                    const Icon(Icons.mic, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Listening for voice input...',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: viewModel.stopVoiceInput,
                      icon: const Icon(
                        Icons.stop,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      tooltip: 'Stop listening',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ),
            // Voice success indicator
            if (viewModel.showVoiceSuccess)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                color: AppColors.success.withOpacity(0.1),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Voice input received!',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            // Input area
            ChatInput(
              onSendMessage: viewModel.sendMessage,
              onInputChanged: viewModel.updateInput,
              onVoiceInput: viewModel.startVoiceInput,
              onStopVoiceInput: viewModel.stopVoiceInput,
              currentInput: viewModel.currentInput,
              isLoading: viewModel.isLoading,
              isListening: viewModel.isListening,
              isSpeechAvailable: ConfigService.isSpeechRecognitionEnabled,
            ),
          ],
        ),
      ),
    );
  }

  @override
  ChatViewModel viewModelBuilder(BuildContext context) => ChatViewModel();
}
