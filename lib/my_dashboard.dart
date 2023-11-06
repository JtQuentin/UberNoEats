import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_app/controller/my_firestore_helper.dart';
import 'package:my_app/globale.dart';
import 'package:my_app/view/my_all_person.dart';
import 'package:my_app/view/my_check_map.dart';
import 'package:my_app/view/my_map.dart';

import 'view/my_ml_view.dart';

class MyDashboard extends StatefulWidget {
  String mail;
  String password;
  MyDashboard({required this.mail, required this.password, super.key});

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  bool isRecorded = false;
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  String? nameImage;
  Uint8List? dataImage;
  int indexCurrent = 0;

  showImagePopUp() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Souhaitez vous enregistrer cette image ?"),
            content: Image.memory(dataImage!),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("NON")),
              TextButton(
                  onPressed: () {
                    // enregistrer les données
                    MyFirestoreHelper()
                        .StorageFiles(
                            datasImage: dataImage!,
                            nameImage: nameImage!,
                            dossier: "IMAGES",
                            uid: moi.uid)
                        .then((value) {
                      setState(() {
                        moi.avatar = value;
                      });
                      Map<String, dynamic> data = {"AVATAR": moi.avatar};
                      MyFirestoreHelper().updateUser(moi.uid, data);
                    });
                    Navigator.pop(context);
                  },
                  child: Text("OUI"))
            ],
          );
        });
  }

  pickImage() async {
    FilePickerResult? resultat = await FilePicker.platform
        .pickFiles(withData: true, type: FileType.image);
    if (resultat != null) {
      nameImage = resultat.files.first.name;
      dataImage = resultat.files.first.bytes;
      showImagePopUp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: indexCurrent,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Carte"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Personne"),
            BottomNavigationBarItem(
                icon: Icon(Icons.rocket_launch), label: "Machine Learning")
          ],
          onTap: (value) {
            setState(() {
              indexCurrent = value;
            });
          }),
      drawer: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: const BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(85),
                topRight: Radius.circular(85))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Spacer(),
            GestureDetector(
              onTap: () {
                pickImage();
              },
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(moi.avatar ?? imageDefault),
              ),
            ),
            const SizedBox(height: 10),
            (isRecorded)
                ? TextField(
                    controller: prenom,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Entrez votre prénom",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  )
                : Container(),
            const SizedBox(height: 10),
            (isRecorded)
                ? TextField(
                    controller: nom,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Entrez votre nom",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  )
                : Container(),
            const SizedBox(height: 10),
            (isRecorded)
                ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isRecorded = false;
                        moi.nom = nom.text;
                        moi.prenom = prenom.text;
                      });
                      Map<String, dynamic> data = {
                        "NOM": nom.text,
                        "PRENOM": prenom.text,
                      };
                      MyFirestoreHelper().updateUser(moi.uid, data);
                    },
                    child: const Text("Enregistrement"))
                : Container(),
            (isRecorded)
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person),
                      Text(
                        moi.fullName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isRecorded = true;
                            });
                          },
                          icon: Icon(Icons.edit))
                    ],
                  ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail),
                SizedBox(height: 10),
                Text(
                  moi.email,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings),
                SizedBox(height: 10),
                Text(
                  "Paramètres",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.exit_to_app),
                label: Text("Deconnexion")),
            const SizedBox(
              height: 25,
            )
          ]),
        ),
      ),
      appBar: AppBar(
        title: Text("Seconde page"),
      ),
      body: bodyPage(),
    );
  }

  Widget bodyPage() {
    switch (indexCurrent) {
      case 0:
        return const MyCheckMap();
      case 1:
        return const MyAllPerson();
      case 2:
        return const MLView();
      default:
        return const Text("Impossible");
    }
  }
}
