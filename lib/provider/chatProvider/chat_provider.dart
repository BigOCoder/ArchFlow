// lib/provider/chatProvider/chat_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:archflow/data/models/chat_message_model.dart';
import 'package:archflow/data/models/app_enums.dart';
import 'package:archflow/provider/chatProvider/chat_state.dart';
import 'package:archflow/core/network/api_client.dart';
import 'package:archflow/data/repositories/auth_repository.dart';
import 'package:uuid/uuid.dart';

class ChatNotifier extends Notifier<ChatState> {
  late final ApiClient _apiClient;
  final Uuid _uuid = const Uuid();

  @override
  ChatState build() {
    _apiClient = ref.watch(apiClientProvider);

    return const ChatState();
  }

  /// Send user message and get AI response
  Future<void> sendMessage(String content) async {
    // Add user message immediately
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: content,
      type: MessageType.user,
      intent: _determineIntent(content),
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      // Call AI API with context
      final response = await _apiClient.dio.post(
        '/ai/chat',
        data: {
          'message': content,
          'context': state.context,
          'phase': state.currentPhase.name,
          'projectId': state.projectId,
          'messageHistory': state.messages
              .map(
                (m) => {
                  'role': m.type == MessageType.user ? 'user' : 'assistant',
                  'content': m.content,
                },
              )
              .toList(),
        },
      );

      // Parse AI response
      final aiMessage = ChatMessage.fromJson(response.data);

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
        currentPhase: _updatePhase(aiMessage),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to get AI response: ${e.toString()}',
      );

      // Add error message to chat
      final errorMessage = ChatMessage(
        id: _uuid.v4(),
        content: 'Sorry, I encountered an error. Please try again.',
        type: MessageType.system,
        intent: MessageIntent.conversational,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(messages: [...state.messages, errorMessage]);
    }
  }

  Future<void> triggerAction(
    String action, {
    Map<String, dynamic>? payload,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _apiClient.dio.post(
        '/ai/action',
        data: {
          'action': action,
          'context': state.context,
          'projectId': state.projectId,
          'payload': payload,
        },
      );

      final actionResult = ChatMessage.fromJson(response.data);

      state = state.copyWith(
        messages: [...state.messages, actionResult],
        isLoading: false,
        currentPhase: _updatePhase(actionResult),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Action failed: ${e.toString()}',
      );
    }
  }

  /// Set project context for conversation
  void setProjectContext(String projectId, Map<String, dynamic> projectData) {
    state = state.copyWith(
      projectId: projectId,
      context: {...?state.context, 'project': projectData},
    );
  }

  /// Set user context (skill level, preferences, etc.)
  void setUserContext(Map<String, dynamic> userProfile) {
    state = state.copyWith(
      context: {...?state.context, 'userProfile': userProfile},
    );
  }

  /// Manually transition to a different phase
  void setPhase(ChatPhase phase) {
    state = state.copyWith(currentPhase: phase);
  }

  /// Clear conversation and start fresh
  void clearChat() {
    state = ChatState(
      context: state.context, // Preserve context
      projectId: state.projectId, // Preserve project link
    );
  }

  /// Delete a specific message
  void deleteMessage(String messageId) {
    state = state.copyWith(
      messages: state.messages.where((m) => m.id != messageId).toList(),
    );
  }

  /// Regenerate last AI response
  Future<void> regenerateLastResponse() async {
    final messages = state.messages;
    if (messages.length < 2) return;

    // Find last user message
    final lastUserMessage = messages.lastWhere(
      (m) => m.type == MessageType.user,
      orElse: () => messages.last,
    );

    // Remove messages after last user message
    final messagesUntilLastUser = messages.sublist(
      0,
      messages.indexOf(lastUserMessage) + 1,
    );

    state = state.copyWith(messages: messagesUntilLastUser);

    // Resend the message
    await sendMessage(lastUserMessage.content);
  }

  /// Export conversation as markdown
  String exportConversation() {
    final buffer = StringBuffer();
    buffer.writeln('# ArchFlow AI Conversation');
    buffer.writeln('**Date:** ${DateTime.now().toLocal()}');
    buffer.writeln('**Phase:** ${state.currentPhase.name}');
    buffer.writeln('\n---\n');

    for (final message in state.messages) {
      final role = message.type == MessageType.user ? '**You**' : '**AI**';
      buffer.writeln('### $role');
      buffer.writeln(message.content);
      buffer.writeln();
    }

    return buffer.toString();
  }

  // ========== PRIVATE HELPER METHODS ==========

  /// Determine message intent based on content
  MessageIntent _determineIntent(String content) {
    final lowerContent = content.toLowerCase();

    // Architecture-related
    if (lowerContent.contains('architecture') ||
        lowerContent.contains('design') ||
        lowerContent.contains('structure')) {
      return MessageIntent.architectureSuggestion;
    }

    // Task-related
    if (lowerContent.contains('task') ||
        lowerContent.contains('breakdown') ||
        lowerContent.contains('feature')) {
      return MessageIntent.taskBreakdown;
    }

    // Requirement-related
    if (lowerContent.contains('requirement') ||
        lowerContent.contains('need') ||
        lowerContent.contains('should')) {
      return MessageIntent.requirementGathering;
    }

    // Code review
    if (lowerContent.contains('review') ||
        lowerContent.contains('code') ||
        lowerContent.contains('improve')) {
      return MessageIntent.codeReview;
    }

    // Traceability
    if (lowerContent.contains('why') ||
        lowerContent.contains('reason') ||
        lowerContent.contains('trace')) {
      return MessageIntent.traceability;
    }

    return MessageIntent.conversational;
  }

  /// Update conversation phase based on AI response
  ChatPhase _updatePhase(ChatMessage aiMessage) {
    // AI can signal phase transitions via metadata
    if (aiMessage.metadata != null &&
        aiMessage.metadata!.containsKey('nextPhase')) {
      final nextPhase = aiMessage.metadata!['nextPhase'] as String;
      return ChatPhase.values.firstWhere(
        (p) => p.name == nextPhase,
        orElse: () => state.currentPhase,
      );
    }

    // Or infer from intent
    switch (aiMessage.intent) {
      case MessageIntent.requirementGathering:
        return ChatPhase.requirementGathering;
      case MessageIntent.architectureSuggestion:
        return ChatPhase.architectureDesign;
      case MessageIntent.taskBreakdown:
        return ChatPhase.taskPlanning;
      case MessageIntent.codeReview:
        return ChatPhase.execution;
      default:
        // Stay in current phase or default to ideaDiscussion
        return state.currentPhase == ChatPhase.idle
            ? ChatPhase.ideaDiscussion
            : state.currentPhase;
    }
  }
}

/// Provider for the chat notifier
final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);

/// Convenience providers for specific state slices
final chatMessagesProvider = Provider<List<ChatMessage>>((ref) {
  return ref.watch(chatProvider).messages;
});

final chatIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(chatProvider).isLoading;
});

final chatPhaseProvider = Provider<ChatPhase>((ref) {
  return ref.watch(chatProvider).currentPhase;
});

final chatErrorProvider = Provider<String?>((ref) {
  return ref.watch(chatProvider).error;
});
