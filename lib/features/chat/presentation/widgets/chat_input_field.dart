import 'package:archflow/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;
  
  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.enabled = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: enabled ? AppColors.brandGreen : Colors.grey,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: enabled ? onSend : null,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
