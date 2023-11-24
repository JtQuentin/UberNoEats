import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  String id;
  String name;
  // Add other relevant fields as necessary, like profileImageUrl, etc.

  ChatUser({
    required this.id,
    required this.name,
    // Initialize other fields if added
  });

  // Factory constructor for creating a ChatUser from a Firestore document
  factory ChatUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ChatUser(
      id: doc.id,
      name: data['name'] ?? '',
      // Assign other fields if added
    );
  }

  // Method to convert ChatUser to a map, useful for Firestore operations
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      // Add other fields to the map if necessary
    };
  }
}
