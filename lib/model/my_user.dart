import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/globale.dart';

class MyUser {
  late String uid;
  late String nom;
  late String prenom;
  late String email;
  int? tel;
  String? avatar;
  List? favoris;
  GeoPoint? gps;

  String get fullName {
    return prenom + " " + nom;
  }

  MyUser() {
    uid = "";
    nom = "";
    prenom = "";
    email = "";
  }

  MyUser.dataBase(DocumentSnapshot snapshot) {
    uid = snapshot.id;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    nom = data["NOM"];
    prenom = data["PRENOM"];
    email = data["EMAIL"];
    tel = data["TEL"] ?? 0;
    avatar = data["AVATAR"] ?? imageDefault;
    favoris = data["FAVORIS"] ?? [];
    gps = data["GPS"] ?? const GeoPoint(0, 0);
  }
}
