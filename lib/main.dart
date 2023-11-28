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
            backgroundColor: Color(0xFF4320dc),
            title: Text(
              "Page de connexion",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true),
        body: Stack(
          children: [
            MyBackground(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                children: [
                  SizedBox(height: 50),
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
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF73e1be)),
                        ),
                        child: Text(
                          "Inscription",
                          style: TextStyle(
                            color: Color(0xFF131313)
                          ),
                        ),
                    ),
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
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF73e1be)),
                        ),
                        child: Text(
                          "Connexion",
                          style: TextStyle(
                            color: Color(0xFF131313)
                          ),
                        ),
                      ),
                  )
                ]
              ),
              )
            ),
          ],
        )
      );
  }
}
