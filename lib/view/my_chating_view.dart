import 'package:flutter/material.dart';
import 'package:my_app/controller/my_firestore_helper.dart';
import 'package:my_app/globale.dart';
import 'package:my_app/model/chat_message.dart';
import 'package:my_app/model/my_chat.dart';
import 'package:my_app/model/my_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyChatingView extends StatefulWidget {
  final MyUser dest;

  const MyChatingView({Key? key, required this.dest}) : super(key: key);

  @override
  State<MyChatingView> createState() => _MyChatingView();
}

class _MyChatingView extends State<MyChatingView> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.dest.nom}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: MyFirestoreHelper().getMessages(moi.uid, widget.dest.uid),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (!snap.hasData) {
                    return Center(child: Text("Aucun message avec ${widget.dest.fullName}"));
                  } else {
                    List documents = snap.data!.docs;
                    List<ChatMessage> messages = documents
                        .map((doc) => ChatMessage.fromFirestore(doc))
                        .toList();
                    return ListView.builder(
                      itemCount: messages.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        ChatMessage message = messages[index];
                        bool isMyMessage = message.senderId == moi.uid;

                        return Align(
                          alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isMyMessage ? Colors.blue : Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              message.message,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      ChatMessage message = ChatMessage(
                        id: '', // Firestore will auto-generate this
                        senderId: moi.uid,
                        receiverId: widget.dest.uid,
                        message: _messageController.text,
                        timestamp: DateTime.now(),
                      );
                      await MyFirestoreHelper().sendMessage(message);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}