import 'package:conversational_ai/ui/common/app_colors.dart';
import 'package:conversational_ai/ui/views/chat/chat_viewmodel.dart';
import 'package:conversational_ai/ui/widgets/chat_bubble.dart';
import 'package:conversational_ai/ui/widgets/chat_input.dart';
import 'package:conversational_ai/ui/widgets/logs_drawer.dart';
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
            icon: const Icon(Icons.history, color: AppColors.textPrimary),
            onPressed: viewModel.toggleLogs,
            tooltip: 'View Conversation Logs',
          ),
        ],
      ),
      body: Column(
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
                          return ChatBubble(
                            message: message,
                            isLastMessage:
                                index == viewModel.messages.length - 1,
                          );
                        },
                      ),
            ),
          ),
          // Input area
          ChatInput(
            onSendMessage: viewModel.sendMessage,
            onInputChanged: viewModel.updateInput,
            currentInput: viewModel.currentInput,
            isLoading: viewModel.isLoading,
          ),
        ],
      ),
      endDrawer:
          viewModel.showLogs
              ? LogsDrawer(
                logs: viewModel.logs,
                onClearLogs: viewModel.clearLogs,
              )
              : null,
    );
  }

  @override
  ChatViewModel viewModelBuilder(BuildContext context) => ChatViewModel();
}
