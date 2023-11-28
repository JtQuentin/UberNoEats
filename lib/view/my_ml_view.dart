import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:my_app/controller/MyPaymentHelper.dart';

class MLView extends StatefulWidget {
  const MLView({super.key});

  @override
  State<MLView> createState() => _MLViewState();
}

class _MLViewState extends State<MLView> {
  //variable
  OnDeviceTranslator translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.french,
      targetLanguage: TranslateLanguage.czech);
  TextEditingController controllerLang = TextEditingController();
  LanguageIdentifier identifier = LanguageIdentifier(confidenceThreshold: 0.1);
  String afficheLang = "";
  String afficheLabel = "";
  Uint8List? imageData;
  String? pathImage;
  ImageLabeler labeler =
      ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.3));

  //méthodes
  langueIdentification() async {
    afficheLang = "";
    if (controllerLang != null && controllerLang.text != "") {
      String lang = controllerLang.text;

      String maLangue = await identifier.identifyLanguage(lang);
      setState(() {
        afficheLang = maLangue;
      });
    }
  }

  multipleIdentification() async {
    afficheLang = "";
    if (controllerLang != null && controllerLang.text != "") {
      String lang = controllerLang.text;
      List mesLangues = await identifier.identifyPossibleLanguages(lang);
      for (IdentifiedLanguage langs in mesLangues) {
        setState(() {
          print(afficheLang);
          afficheLang +=
              "La langue est ${langs.languageTag} avec une confiance ${(langs.confidence * 100).toInt()}%\n";
        });
      }
    }
  }

  translateSentence() async {
    afficheLang = "";
    if (controllerLang != null && controllerLang.text != "") {
      String lang = await translator.translateText(controllerLang.text);
      setState(() {
        afficheLang = lang;
      });
    }
  }

  objetIdentification() async {
    afficheLabel = "";
    if (imageData != null) {
      InputImage image = InputImage.fromFilePath(pathImage!);
      List<ImageLabel> labelling = await labeler.processImage(image);
      for (ImageLabel image in labelling) {
        setState(() {
          afficheLabel +=
              "${image.label} avec une confiance de ${(image.confidence * 100).toInt()} %\n";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controllerLang,
            ),
            ElevatedButton(
              onPressed: langueIdentification,
              child: const Text("Detection d'une langue"),
            ),
            ElevatedButton(
              onPressed: multipleIdentification,
              child: const Text("Detection de plusieurs langues"),
            ),
            ElevatedButton(
              onPressed: translateSentence,
              child: const Text("Traduction"),
            ),
            Text(afficheLang),
            ElevatedButton(
                onPressed: () async {
                  FilePickerResult? resultat = await FilePicker.platform
                      .pickFiles(withData: true, type: FileType.image);
                  if (resultat != null) {
                    setState(() {
                      imageData = resultat.files.first.bytes;
                      pathImage = resultat.files.first.path;
                    });
                  }
                },
                child: const Text("upload")),
            (imageData == null) ? Container() : Image.memory(imageData!),
            ElevatedButton(
                onPressed: objetIdentification, child: Text("Etiquetage")),
            Text(afficheLabel),
            ElevatedButton(
              onPressed: () {
                redirectToCheckout(context);
              },
              child: Text('Payer avec Stripe'),
            )
          ],
        ),
      ),
    );
  }
}
