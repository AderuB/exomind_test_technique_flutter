import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_flutter_exomind_benamara/weather_model.dart';
import 'package:http/http.dart' as http;

class ServiceApi {
  final baseApi = "http://api.openweathermap.org/data/2.5/weather?q=";
  String myKey = "&appid=5c2193b233616f7148f642243a1cebd5";
  String units = "&units=metric";
  String lang = "&lang=fr";

  void getWeather(String city, Map<String, dynamic> mapCities) async {
    Weather weather;

    String apiString = baseApi + city + units + lang + myKey;
    final uri = Uri.parse(apiString);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      //Récupération des données json
      Map map = json.decode(response.body);
      weather = Weather(map);

      mapCities[city]["temperature"] = weather.temp;
      mapCities[city]["description"] = weather.description;

    } else {
      // En cas d'erreur de reponse del'api, un message d'erreur s'affiche sans pour autant arrêter
      Fluttertoast.showToast(
          msg: "Erreur lors de la récupération des données de .\n\t$city",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.white.withOpacity(0.3),
          textColor: Colors.black,
          timeInSecForIosWeb: 3);
    }
  }
}
