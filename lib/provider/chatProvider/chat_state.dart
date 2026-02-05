// lib/provider/chatProvider/chat_state.dart

import 'package:archflow/data/models/chat_message_model.dart';
import 'package:archflow/data/models/app_enums.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final ChatPhase currentPhase;
  final String? projectId;
  final Map<String, dynamic>? context;
  
  const ChatState({ 
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.currentPhase = ChatPhase.idle,
    this.projectId,
    this.context,
  });
  
  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    ChatPhase? currentPhase,
    String? projectId,
    Map<String, dynamic>? context,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPhase: currentPhase ?? this.currentPhase,
      projectId: projectId ?? this.projectId,
      context: context ?? this.context,
    );
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatState &&
          runtimeType == other.runtimeType &&
          messages == other.messages &&
          isLoading == other.isLoading &&
          error == other.error &&
          currentPhase == other.currentPhase &&
          projectId == other.projectId;
  
  @override
  int get hashCode =>
      messages.hashCode ^
      isLoading.hashCode ^
      error.hashCode ^
      currentPhase.hashCode ^
      projectId.hashCode;
}
