import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/controller/my_firestore_helper.dart';
import 'package:my_app/globale.dart';
import 'package:my_app/model/my_user.dart' show MyUser;

class MyChatingView extends StatefulWidget {
  final MyUser dest;
  final String receiverUserID;
  const MyChatingView(
      {super.key, required this.receiverUserID, required this.dest});

  @override
  State<MyChatingView> createState() => _MyChatingViewState();
}

class _MyChatingViewState extends State<MyChatingView> {
  final TextEditingController _messageController = TextEditingController();
  final MyFirestoreHelper _chatService = MyFirestoreHelper();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.dest.uid, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.dest.nom}'),
      ),
      body: Column(children: [
        Expanded(
          child: _buildMessageList(),
        ),
        _buildMessageInput(),
      ]),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.dest.uid, moi.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error' + snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == moi.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
        alignment: alignment,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: data['senderId'] == moi.uid
                ? Colors.blue
                : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data['message'],
              style: TextStyle(
                color: data['senderId'] == moi.uid
                ? Colors.white
                : Colors.black,
              ),
            ),
        ));
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: const InputDecoration(hintText: 'Enter Message'),
            obscureText: false,
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.send,
            size: 40,
          ),
        )
      ],
    );
  }
}
