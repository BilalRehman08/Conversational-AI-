import 'package:conversational_ai/models/conversation_log.dart';
import 'package:conversational_ai/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogsDrawer extends StatelessWidget {
  final List<ConversationLog> logs;
  final VoidCallback onClearLogs;

  const LogsDrawer({super.key, required this.logs, required this.onClearLogs});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            color: AppColors.primary,
            child: Row(
              children: [
                const Icon(Icons.history, color: AppColors.textLight, size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Conversation Logs',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (logs.isNotEmpty)
                  IconButton(
                    icon: const Icon(
                      Icons.clear_all,
                      color: AppColors.textLight,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Clear Logs'),
                              content: const Text(
                                'Are you sure you want to clear all conversation logs?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    onClearLogs();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Clear'),
                                ),
                              ],
                            ),
                      );
                    },
                    tooltip: 'Clear all logs',
                  ),
              ],
            ),
          ),
          Expanded(
            child:
                logs.isEmpty
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No conversation logs yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log =
                            logs[logs.length - 1 - index]; // Show newest first
                        return _LogItem(log: log);
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  final ConversationLog log;

  const _LogItem({required this.log});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ExpansionTile(
        title: Text(
          log.userMessage,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy - HH:mm').format(log.timestamp),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(log.userMessage),
                const SizedBox(height: 16),
                const Text(
                  'AI Response:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(log.aiResponse),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
