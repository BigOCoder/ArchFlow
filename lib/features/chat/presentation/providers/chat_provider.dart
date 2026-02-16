// lib/features/chat/presentation/providers/chat_provider.dart

import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/core/network/api_client.dart';
import 'package:archflow/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:archflow/features/chat/data/models/chat_message_model.dart';
import 'package:archflow/features/chat/presentation/providers/chat_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    // Validate project ID
    if (state.projectId == null) {
      state = state.copyWith(
        error: 'Please select a project first',
      );
      return;
    }

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
      // Parse project ID
      final projectId = int.tryParse(state.projectId!);
      if (projectId == null) {
        throw Exception('Invalid project ID');
      }

      // Call backend API
      final response = await _apiClient.dio.post(
        '/ai/chat',
        data: {
          'projectId': projectId,
          'message': content,
        },
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      // Handle different response codes
      if (response.statusCode == 200) {
        final aiResponseText = response.data as String;

        // Create AI message with plain text content
        final aiMessage = ChatMessage(
          id: _uuid.v4(),
          content: aiResponseText,
          type: MessageType.ai,
          intent: _inferIntentFromResponse(aiResponseText),
          timestamp: DateTime.now(),
        );

        state = state.copyWith(
          messages: [...state.messages, aiMessage],
          isLoading: false,
          currentPhase: _updatePhase(aiMessage),
        );
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('Access denied to this project.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage;

      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please check your internet.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Response timeout. Please try again.';
      } else if (e.response?.statusCode == 401) {
        errorMessage = 'Authentication failed. Please login again.';
      } else if (e.response?.statusCode == 403) {
        errorMessage = 'Access denied to this project.';
      } else if (e.response?.statusCode == 404) {
        errorMessage = 'API endpoint not found.';
      } else {
        errorMessage = 'Network error: ${e.message}';
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );

      // Add error message to chat
      final errorChatMessage = ChatMessage(
        id: _uuid.v4(),
        content: 'Sorry, I encountered an error. Please try again.',
        type: MessageType.system,
        intent: MessageIntent.conversational,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, errorChatMessage],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Unexpected error: ${e.toString()}',
      );

      // Add error message to chat
      final errorChatMessage = ChatMessage(
        id: _uuid.v4(),
        content: 'Sorry, something went wrong. Please try again.',
        type: MessageType.system,
        intent: MessageIntent.conversational,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, errorChatMessage],
      );
    }
  }

  /// Trigger a specific action (if your backend supports it)
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

  /// Set project ID before starting chat
  void setProjectId(int projectId) {
    state = state.copyWith(
      projectId: projectId.toString(),
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
      context: state.context,
      projectId: state.projectId,
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

    final lastUserMessage = messages.lastWhere(
      (m) => m.type == MessageType.user,
      orElse: () => messages.last,
    );

    final messagesUntilLastUser = messages.sublist(
      0,
      messages.indexOf(lastUserMessage) + 1,
    );

    state = state.copyWith(messages: messagesUntilLastUser);

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

    if (lowerContent.contains('architecture') ||
        lowerContent.contains('design') ||
        lowerContent.contains('structure')) {
      return MessageIntent.architectureSuggestion;
    }

    if (lowerContent.contains('task') ||
        lowerContent.contains('breakdown') ||
        lowerContent.contains('feature')) {
      return MessageIntent.taskBreakdown;
    }

    if (lowerContent.contains('requirement') ||
        lowerContent.contains('need') ||
        lowerContent.contains('should')) {
      return MessageIntent.requirementGathering;
    }

    if (lowerContent.contains('review') ||
        lowerContent.contains('code') ||
        lowerContent.contains('improve')) {
      return MessageIntent.codeReview;
    }

    if (lowerContent.contains('why') ||
        lowerContent.contains('reason') ||
        lowerContent.contains('trace')) {
      return MessageIntent.traceability;
    }

    return MessageIntent.conversational;
  }

  /// Infer intent from AI response content
  MessageIntent _inferIntentFromResponse(String response) {
    final lower = response.toLowerCase();

    if (lower.contains('architecture') || lower.contains('design pattern')) {
      return MessageIntent.architectureSuggestion;
    } else if (lower.contains('task') || lower.contains('step')) {
      return MessageIntent.taskBreakdown;
    } else if (lower.contains('requirement')) {
      return MessageIntent.requirementGathering;
    } else if (lower.contains('code') || lower.contains('implementation')) {
      return MessageIntent.codeReview;
    }

    return MessageIntent.conversational;
  }

  /// Update conversation phase based on AI response
  ChatPhase _updatePhase(ChatMessage aiMessage) {
    if (aiMessage.metadata != null &&
        aiMessage.metadata!.containsKey('nextPhase')) {
      final nextPhase = aiMessage.metadata!['nextPhase'] as String;
      return ChatPhase.values.firstWhere(
        (p) => p.name == nextPhase,
        orElse: () => state.currentPhase,
      );
    }

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
