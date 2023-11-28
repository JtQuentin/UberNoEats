import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  // String id;
  String senderId;
  String receiverId;
  String message;
  Timestamp timestamp;

  ChatMessage({
    // required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  // Method to convert ChatMessage to a map, useful for Firestore operations
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
