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
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {});
    });
  }

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
                    messages = documents
                        .map((doc) => ChatMessage.fromFirestore(doc))
                        .toList();
                    return ListView.builder(
                      itemCount: messages.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        ChatMessage message = messages[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: message.senderId == moi.uid
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: message.senderId == moi.uid
                                      ? Color(0xFF4320dc)
                                      : Color(0xFF73e1be),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  message.message,
                                  style: TextStyle(
                                    color: message.senderId == moi.uid
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
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
                      hintText: 'Entrez votre message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      ChatMessage message = ChatMessage(
                        id: '', // document id auto-generate by Firestore
                        senderId: moi.uid,
                        receiverId: widget.dest.uid,
                        message: _messageController.text,
                        timestamp: DateTime.now(),
                      );
                      await MyFirestoreHelper().sendMessage(message);
                      _messageController.clear();

                      // mise à jour de la liste des messages après l'envoi
                      List<ChatMessage> updatedMessages = List.from(messages);
                      updatedMessages.insert(0, message);

                      setState(() {
                        messages = updatedMessages;
                      });
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

