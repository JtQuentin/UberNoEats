import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_app/model/chat_message.dart';
import 'package:my_app/model/my_chat.dart';
import 'package:my_app/model/my_user.dart';

class MyFirestoreHelper {
  //gérer les opérations dans la BDD
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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


  Future<void> sendMessage(ChatMessage message) {
    return _firestore.collection('Messages').add({
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'message': message.message,
      'timestamp': message.timestamp,
    });
  }

  // Stream to listen for messages
  Stream<QuerySnapshot> getMessages(String senderId, String receiverId) {
    return FirebaseFirestore.instance
        .collection('Messages')
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }


}
