import 'package:cloud_firestore/cloud_firestore.dart';

class MyChat {
  late String id;
  late String dest;
  late String exp;
  late String message;

  MyChat() {
    id = "";
    dest = "";
    exp = "";
    message = "";
  }

  MyChat.dataBase(DocumentSnapshot snapshot) {
    id = snapshot.id;

    // Check if snapshot data is a Map
    var data = snapshot.data();
    if (data is! Map<String, dynamic>) {
      throw FormatException("Snapshot data is not a Map<String, dynamic>");
    }

    // Safely retrieve values, providing default values for missing/null fields
    dest = data["DEST"] ?? "default_dest"; // Replace 'default_dest' with an appropriate default
    exp = data["EXP"] ?? "default_exp"; // Replace 'default_exp' with an appropriate default
    message = data["MESSAGE"] ?? "default_message"; // Replace 'default_message' with an appropriate default
  }
}
