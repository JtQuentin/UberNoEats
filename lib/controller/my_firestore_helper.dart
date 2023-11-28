import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:my_app/model/chat_message.dart';
import 'package:my_app/model/my_chat.dart';
import 'package:my_app/model/my_user.dart';
import 'package:rxdart/rxdart.dart';

class MyFirestoreHelper {
  //gérer les opérations dans la BDD
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //attributs
  final auth = FirebaseAuth.instance;
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");
  final cloudMessage = FirebaseFirestore.instance.collection("MESSAGES");
  final storage = FirebaseStorage.instance;

  //méthode

  //création d'un utilisateur
  Future<MyUser> CreateUserDataBase(String email, String password) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String uid = credential.user!.uid;
    Map<String, dynamic> data = {"NOM": "", "PRENOM": "", "EMAIL": email};

    addUser(uid, data);
    return getUser(uid);
  }

  Future<MyUser> getUser(String uid) async {
    DocumentSnapshot snapshot = await cloudUsers.doc(uid).get();
    return MyUser.dataBase(snapshot);
  }

  addUser(String uid, Map<String, dynamic> data) {
    cloudUsers.doc(uid).set(data);
  }

  updateUser(String uid, Map<String, dynamic> data) {
    cloudUsers.doc(uid).update(data);
  }

  deleteUser(String uid) {
    cloudUsers.doc(uid).delete();
  }

  //connexion d'un utilisateur
  Future<MyUser> ConnectUserDataBase(String email, String password) async {
    UserCredential credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    String uid = credential.user!.uid;
    return getUser(uid);
  }

  Future<String> StorageFiles(
      {required Uint8List datasImage,
      required String nameImage,
      required String dossier,
      required String uid}) async {
    TaskSnapshot snapshot =
        await storage.ref("$dossier/$uid/$nameImage").putData(datasImage);
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  // Partie messagerie
  Future<MyChat> getMessage(String id) async {
    DocumentSnapshot snapshot = await cloudMessage.doc(id).get();
    return MyChat.dataBase(snapshot);
  }

  addMessage(String id, Map<String, dynamic> data) {
    cloudMessage.doc(id).set(data);
  }

  updateMessage(String id, Map<String, dynamic> data) {
    cloudMessage.doc(id).update(data);
  }

  deleteMessage(String id) {
    cloudMessage.doc(id).delete();
  }

  // Future<void> sendMessage(ChatMessage message) {
  //   return _firestore.collection('MESSAGES').add({
  //     'senderId': message.senderId,
  //     'receiverId': message.receiverId,
  //     'message': message.message,
  //     'timestamp': message.timestamp,
  //   });
  // }

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    ChatMessage newMessage = ChatMessage(
      senderId: currentUserId,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('MESSAGES')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String user1Id, String user2Id) {
    // Stream<QuerySnapshot> stream1 = _firestore
    //     .collection('MESSAGES')
    //     .where('senderId', isEqualTo: user1Id)
    //     .where('receiverId', isEqualTo: user2Id)
    //     .snapshots();

    // Stream<QuerySnapshot> stream2 = _firestore
    //     .collection('MESSAGES')
    //     .where('senderId', isEqualTo: user2Id)
    //     .where('receiverId', isEqualTo: user1Id)
    //     .snapshots();

    // return Rx.merge([stream1, stream2]).distinct();

    List<String> ids = [user1Id, user2Id];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('MESSAGES')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
