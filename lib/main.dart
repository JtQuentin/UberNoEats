import 'package:flutter/material.dart';
import 'package:my_app/controller/my_animation.dart';
import 'package:my_app/controller/my_firestore_helper.dart';
import 'package:my_app/controller/my_permission_access_photos.dart';
import 'package:my_app/globale.dart';
import 'package:my_app/my_dashboard.dart';
import 'package:my_app/view/my_background.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MyPermissionAccessPhotos().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //variables
  String email = '';
  TextEditingController password = TextEditingController();

  //méthode
  popError() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Adresse mail ou mot de passe erroné"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.amberAccent,
            title: Text("Page de connexion"),
            centerTitle: true),
        body: Stack(
          children: [
            MyBackground(),
            Column(children: [
              MyAnimation(
                duree: 1,
                child: Image.network(
                    "data:image/jpeg;base64,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"),
              ),
              const SizedBox(height: 10),
              MyAnimation(
                duree: 2,
                child: TextField(
                    onChanged: (valueTapped) {
                      setState(() {
                        email = valueTapped;
                      });
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.mail),
                        border: OutlineInputBorder(),
                        labelText: 'Adresse mail')),
              ),
              SizedBox(height: 30),
              MyAnimation(
                duree: 3,
                child: TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: const Icon(Icons.remove_red_eye),
                        border: OutlineInputBorder(),
                        labelText: 'Mot de passe')),
              ),
              SizedBox(height: 30),
              MyAnimation(
                duree: 4,
                child: ElevatedButton(
                    onPressed: () {
                      print("Je m'inscris'");
                      MyFirestoreHelper()
                          .CreateUserDataBase(email, password.text)
                          .then((value) => {
                                setState(() {
                                  moi = value;
                                }),
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MyDashboard(
                                      mail: email, password: password.text);
                                }))
                              })
                          .catchError((onError) {
                        popError();
                      });
                    },
                    child: Text("Inscription")),
              ),
              SizedBox(height: 10),
              MyAnimation(
                duree: 5,
                child: ElevatedButton(
                    onPressed: () {
                      MyFirestoreHelper()
                          .ConnectUserDataBase(email, password.text)
                          .then((value) => {
                                setState(() {
                                  moi = value;
                                }),
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MyDashboard(
                                      mail: email, password: password.text);
                                }))
                              })
                          .catchError((onError) {
                        //un message d'erreur
                        popError();
                      });
                    },
                    child: Text("Connexion")),
              )
            ]),
          ],
        )

        /*SingleChildScrollView(
            child: Column(children: [
          Container(
              height: 400,
              width: 200,
              color: Colors.yellow,
              child: Text("Coucou", style: TextStyle(color: Colors.blue))),
          Container(
              height: 400,
              width: 200,
              color: Colors.red,
              child: Text("Coucou", style: TextStyle(color: Colors.blue))),
          Container(
              height: 400,
              width: 200,
              color: Colors.blue,
              child: Text("Coucou", style: TextStyle(color: Colors.blue))),
          Container(
              height: 400,
              width: 200,
              color: Colors.red,
              child: Text("Coucou", style: TextStyle(color: Colors.blue)))
        ]))

        Image.asset()
      
      TextField(
        obscureText:true
      
      )
      
      
      Container(
          height : 400,
          width : 200,
          color: Colors.yellow,
          child : Text("Coucou", style : TextStyle(color: Colors.blue))
      
      )*/

        );
  }
}
