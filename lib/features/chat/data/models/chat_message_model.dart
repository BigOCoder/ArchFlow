

import 'package:archflow/core/constants/app_enums.dart';

class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final MessageIntent intent;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final List<String>? suggestedActions;
  
  ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.intent,
    required this.timestamp,
    this.metadata,
    this.suggestedActions,
  });
  
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      intent: MessageIntent.values.firstWhere(
        (e) => e.name == json['intent'],
      ),
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'],
      suggestedActions: json['suggestedActions'] != null
          ? List<String>.from(json['suggestedActions'])
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.name,
      'intent': intent.name,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
      'suggestedActions': suggestedActions,
    };
  }
}