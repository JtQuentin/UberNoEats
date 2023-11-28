import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/controller/my_firestore_helper.dart';
import 'package:my_app/model/my_user.dart' show MyUser;
// import 'package:flutter/material.dart';
// import 'package:my_app/controller/my_firestore_helper.dart';
// import 'package:my_app/globale.dart';
// import 'package:my_app/model/chat_message.dart';
// import 'package:my_app/model/my_chat.dart';
// import 'package:my_app/model/my_user.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// class MyChatingView extends StatefulWidget {
//   final MyUser dest;

//   const MyChatingView({Key? key, required this.dest}) : super(key: key);

//   @override
//   State<MyChatingView> createState() => _MyChatingView();
// }
// class _MyChatingView extends State<MyChatingView> {
//   final TextEditingController _messageController = TextEditingController();
//   List<ChatMessage> messages = [];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with ${widget.dest.nom}'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: MyFirestoreHelper().getMessages(moi.uid, widget.dest.uid),
//               builder: (context, snap) {
//                 if (snap.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else {
//                   if (!snap.hasData) {
//                     return Center(child: Text("Aucun message avec ${widget.dest.fullName}"));
//                   } else {
//                     List documents = snap.data!.docs;
//                     messages = documents
//                         .map((doc) => ChatMessage.fromFirestore(doc))
//                         .toList();
//                     return ListView.builder(
//                       itemCount: messages.length,
//                       reverse: true,
//                       itemBuilder: (context, index) {
//                         ChatMessage message = messages[index];
//                         return Container(
//                           margin: EdgeInsets.symmetric(vertical: 10),
//                           child: Row(
//                             mainAxisAlignment: message.senderId == moi.uid
//                                 ? MainAxisAlignment.end
//                                 : MainAxisAlignment.start,
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 10, vertical: 5),
//                                 decoration: BoxDecoration(
//                                   color: message.senderId == moi.uid
//                                       ? Colors.blue
//                                       : Colors.grey[300],
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Text(
//                                   message.message,
//                                   style: TextStyle(
//                                     color: message.senderId == moi.uid
//                                         ? Colors.white
//                                         : Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   }
//                 }
//               },
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Entrez votre message',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () async {
//                     if (_messageController.text.isNotEmpty) {
//                       ChatMessage message = ChatMessage(
//                         // id: '', // document id auto-generate by Firestore
//                         senderId: moi.uid,
//                         receiverId: widget.dest.uid,
//                         message: _messageController.text,
//                         timestamp: DateTime.now(),
//                       );
//                       await MyFirestoreHelper().sendMessage(message);
//                       _messageController.clear();

//                       // mise à jour de la liste des messages après l'envoi
//                       List<ChatMessage> updatedMessages = List.from(messages);
//                       updatedMessages.insert(0, message);

//                       setState(() {
//                         messages = updatedMessages;
//                       });
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
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
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
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
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
        alignment: alignment,
        child: Column(
          children: [Text(data['message'])],
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
            Icons.arrow_upward,
            size: 40,
          ),
        )
      ],
    );
  }
}
