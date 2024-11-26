import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Tasksheet-Aufgabe ohne Future-Builder
class Tasksheet extends StatefulWidget {
  const Tasksheet({super.key});

  @override
  State<Tasksheet> createState() => _TasksheetState();
}

class _TasksheetState extends State<Tasksheet> {
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
      // Anfrage ist fehlgeschlagen
      Map<String, dynamic> error = jsonDecode(response.body);

      // Fehlernachricht zurückgeben
      return "Fehler: ${error["message"]}";
    }
  }

  // Platzhalter Variable, der entweder die Daten oder den Fehler speichert
  String data = "Noch keine Daten";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Zeigt den Fehler oder die Daten aus der API an
          Text(data),
          const SizedBox(
            height: 10,
          ),

          // Löst die Anfrage aus und speichert die Antwort in unsere Variable `data`
          ElevatedButton(
              onPressed: () async {
                String dataFromAPI = await getDatafromAPI();
                setState(() {
                  data = dataFromAPI;
                });
              },
              child: const Text("Daten holen"))
        ],
      ),
    ));
  }
}
