import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Tasksheet-Aufgabe mit Future-Builder
class TaskSheetBonus extends StatefulWidget {
  const TaskSheetBonus({super.key});

  @override
  State<TaskSheetBonus> createState() => _TaskSheetBonusState();
}

class _TaskSheetBonusState extends State<TaskSheetBonus> {
  /// Anfrage zu unserer API namens dummyjson
  Future<String> getDatafromAPI() async {
    // Unsere URL zur API
    // Ändere die URL zu https://dummyjson.com/products/1299239392 um, um einen Fehler auszulögen
    String url = "https://dummyjson.com/products/1";

    // URL in eine URI umwandeln
    // Die URI ist eine Vorgabe des http-packages, die benötigt wird, um eine Anfrage ins Internet zu stellen
    // (da kommen wir leider mit einer URL nicht drum herum, jedoch bietet die URI-Klasse eine Methode namens `Uri.parse`, die den
    // Job für uns übernimmt)
    Uri uri = Uri.parse(url);

    // URI:
    // - Scheme: https
    // - Host: dummyjson.com
    // - Path: products/1

    // Anfrage versenden
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      /// Anfrage war erfolgreich

      // Daten in eine MAP konvertieren
      Map<String, dynamic> data = jsonDecode(response.body);

      // Title zurückgeben (ihr könnte an der Stelle auch andere Felder wie price zurückgeben,
      // jedoch muss dann (da price ein double ist) in ein String konvertiert werden)
      return data["title"];
    } else {
      // Anfrage ist fehlgeschlagen und dekodieren den JSON-String in eine MAP
      Map<String, dynamic> error = jsonDecode(response.body);

      // Wie kam ich darauf? - Printed erstmal aus, was die API zurückgibt, wenn die Anfrage erfolgreich war und wenn sie
      // fehlschlug.

      // Hier gab mir die API als fehler folgendes JSON zurück:
      // {'message': '...'}, daher wusste ich, dass ich auf message zugreifen musste, um den Fehlertext zu erhalten
      final String message = error["message"];

      // Hier müssen wir einen Fehler auswerfen, damit der FutureBuilder erkennt, dass ein Fehler aufgetreten ist.
      // Wenn jedoch hier die message zurückgegeben wird also `return message;`, dann wird der Fehler nicht als Fehler sondern als Data erkannt und
      // dass kann zu Errors in eurer App führen.

      // Probiere es selbst, ersetze diese Zeile 60 mit folgendem Code `return message;` und schaue was im UI passiert
      throw ErrorDescription(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: getDatafromAPI(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    "Fehler: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  return Text("Daten: ${snapshot.data}");
                }
              }),
        ],
      ),
    ));
  }
}
