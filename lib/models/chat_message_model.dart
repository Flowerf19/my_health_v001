// lib/models/chat_message_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String message;
  final String senderId;
  final DateTime timestamp;
  final bool isBot;

  ChatMessage({
    required this.id,
    required this.message,
    required this.senderId,
    required this.timestamp,
    required this.isBot,
  });

  // Convert ChatMessage to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'message': message,
      'senderId': senderId,
      // Chuyển đổi DateTime thành Timestamp để lưu lên Firestore
      'timestamp': Timestamp.fromDate(timestamp),
      'isBot': isBot,
    };
  }

  // Create ChatMessage from Firestore data
  factory ChatMessage.fromFirestore(Map<String, dynamic> data, String id) {
    return ChatMessage(
      id: id,
      message: data['message'] as String? ?? '',
      senderId: data['senderId'] as String? ?? '',
      // Chuyển Timestamp về thành DateTime
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isBot: data['isBot'] as bool? ?? false,
    );
  }
}
