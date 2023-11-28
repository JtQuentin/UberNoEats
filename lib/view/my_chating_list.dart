import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/controller/my_firestore_helper.dart';
import 'package:my_app/globale.dart';
import 'package:my_app/model/my_user.dart';
import 'package:my_app/view/my_chating_view.dart';

class MyChatingList extends StatefulWidget {
  const MyChatingList({super.key});

  @override
  State<MyChatingList> createState() => _MyChatingList();
}

class _MyChatingList extends State<MyChatingList> {
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
                  if (moi.uid != otherUser.uid) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyChatingView(dest: otherUser),
                          ),
                        );
                      },
                      child: Dismissible(
                        key: Key(otherUser.uid),
                        background: Container(
                          color: Colors.red,
                        ),
                        child: Card(
                          elevation: 5,
                          color: Color(0xFF4320dc),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 68,
                              backgroundImage:
                                  NetworkImage(otherUser.avatar ?? imageDefault),
                            ),
                            title: Text(
                              otherUser.fullName,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              otherUser.email,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }
          }
        });
  }
}
