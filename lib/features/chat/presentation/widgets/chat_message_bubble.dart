import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/features/chat/data/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(context, false),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppColors.brandGreen
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: isUser
                        ? null
                        : Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                  ),
                  child: isUser
                      ? Text(
                          message.content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        )
                      : MarkdownBody(
                          data: message.content,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 15,
                            ),
                          ),
                        ),
                ),

                // Suggested actions
                if (message.suggestedActions != null &&
                    message.suggestedActions!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: message.suggestedActions!
                          .map((action) => _buildActionChip(action, context))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildAvatar(context, true),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, bool isUser) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: isUser
          ? AppColors.brandGreen.withOpacity(0.2)
          : Theme.of(context).colorScheme.surface,
      child: Icon(
        isUser ? Icons.person : Icons.psychology,
        size: 18,
        color: isUser
            ? AppColors.brandGreen
            : Theme.of(context).iconTheme.color,
      ),
    );
  }

  Widget _buildActionChip(String action, BuildContext context) {
    return ActionChip(
      label: Text(action, style: const TextStyle(fontSize: 12)),
      onPressed: () {
        // Handle action
      },
      side: BorderSide(color: AppColors.brandGreen.withOpacity(0.3)),
    );
  }
}
