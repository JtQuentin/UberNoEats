import 'package:flutter/material.dart';
import 'package:my_app/controller/my_firestore_helper.dart';
import 'package:my_app/globale.dart';
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: MyFirestoreHelper().cloudMessage.snapshots(),
      builder: (context, snap){
        if(snap.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(),
            );
        }
        else{
          if(!snap.hasData) { return Center(child: Text("Aucun message avec ${widget.dest.fullName}"));}
          else{
            List documents = snap.data!.docs;
            List<MyChat> filteredMessages = documents
            .map((doc) => MyChat.dataBase(doc))
            .where((message) =>
              message.dest == widget.dest.uid ||
              message.exp == moi.uid ||
              message.exp == widget.dest.uid ||
              message.dest == moi.uid
            )
            .toList();
            return ListView.builder(
              itemCount: filteredMessages.length,
              itemBuilder: (context, index) {
                MyChat message = filteredMessages[index];
                bool isMyMessage = false; 
                if(message.dest == moi.uid || message.exp == moi.uid) { isMyMessage = true; }

                return Align(
                  alignment: isMyMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isMyMessage
                          ? Colors.blue
                          : Colors.grey,
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
    );
  }
}
