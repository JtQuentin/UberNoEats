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
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    dest = data["DEST"];
    exp = data["EXP"];
    message = data["MESSAGE"];
  }
}
