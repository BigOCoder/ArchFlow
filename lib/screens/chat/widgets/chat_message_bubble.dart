// lib/screens/chat/widgets/chat_message_bubble.dart

import 'package:archflow/data/models/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:archflow/data/models/chat_message_model.dart';
import 'package:archflow/themeData/app_color.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUser = message.type == MessageType.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(isDark, false),
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
                        : (isDark
                              ? AppColors.darkSurface
                              : AppColors.lightSurface),
                    borderRadius: BorderRadius.circular(16),
                    border: isUser
                        ? null
                        : Border.all(
                            color: isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider,
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
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
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
                          .map((action) => _buildActionChip(action, isDark))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildAvatar(isDark, true),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isDark, bool isUser) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: isUser
          ? AppColors.brandGreen.withOpacity(0.2)
          : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
      child: Icon(
        isUser ? Icons.person : Icons.psychology,
        size: 18,
        color: isUser
            ? AppColors.brandGreen
            : (isDark ? AppColors.darkIcon : AppColors.lightIcon),
      ),
    );
  }

  Widget _buildActionChip(String action, bool isDark) {
    return ActionChip(
      label: Text(action, style: const TextStyle(fontSize: 12)),
      onPressed: () {
        // Handle action
      },
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      side: BorderSide(color: AppColors.brandGreen.withOpacity(0.3)),
    );
  }
}
