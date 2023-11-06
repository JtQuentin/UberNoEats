import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/controller/my_firestore_helper.dart';
import 'package:my_app/globale.dart';
import 'package:my_app/model/my_user.dart';
import 'package:permission_handler/permission_handler.dart';

class MyAllPerson extends StatefulWidget {
  const MyAllPerson({super.key});

  @override
  State<MyAllPerson> createState() => _MyAllPersonState();
}

class _MyAllPersonState extends State<MyAllPerson> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: MyFirestoreHelper().cloudUsers.snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (!snap.hasData) {
              return const Center(child: Text("Aucune info"));
            } else {
              List documents = snap.data!.docs;
              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    MyUser otherUser = MyUser.dataBase(documents[index]);
                    return Dismissible(
                      key: Key(otherUser.uid),
                      background: Container(
                        color: Colors.red,
                      ),
                      child: Card(
                        elevation: 5,
                        color: Colors.amberAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 68,
                            backgroundImage:
                                NetworkImage(otherUser.avatar ?? imageDefault),
                          ),
                          title: Text(otherUser.fullName),
                          subtitle: Text(otherUser.email),
                        ),
                      ),
                    );
                  });
            }
          }
        });
  }
}
