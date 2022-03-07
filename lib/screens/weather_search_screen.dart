// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_flutter_exomind_benamara/services_api.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class WeatherSearchScreen extends StatefulWidget {
  WeatherSearchScreen({Key key}) : super(key: key);

  @override
  State<WeatherSearchScreen> createState() => _WeatherSearchScreenState();
}

class _WeatherSearchScreenState extends State<WeatherSearchScreen> {
  double progress = 0;
  bool isAchieved = false;
  bool isLoading = false;
  Timer _timer;
  String currentMsg = "";

  List<String> loadingMessages = [
    "Nous téléchargeons les données..",
    "C'est presque fini...",
    "Plus que quelques secondes avant d'avoir le résultat..."
  ];

  List<String> cities = ["Rennes", "Paris", "Nantes", "Bordeaux", "Lyon"];

  Map<String, dynamic> mapCities = {
    "Rennes": {"mapTemperature": 0, "description": ""},
    "Paris": {"temperature": 0, "description": ""},
    "Nantes": {"temperature": 0, "description": ""},
    "Bordeaux": {"temperature": 0, "description": ""},
    "Lyon": {"temperature": 0, "description": ""},
  };

  /* 
  * Fonction pour réinitialiser la map qui conserve les données météos des villes à un moment précis. 
  */
  void resetMapCities() {
    mapCities["Rennes"]["temperature"] = 0;
    mapCities["Rennes"]["description"] = "";
    mapCities["Paris"]["temperature"] = 0;
    mapCities["Paris"]["description"] = "";
    mapCities["Nantes"]["temperature"] = 0;
    mapCities["Nantes"]["description"] = "";
    mapCities["Bordeaux"]["temperature"] = 0;
    mapCities["Bordeaux"]["description"] = "";
    mapCities["Lyon"]["temperature"] = 0;
    mapCities["Lyon"]["description"] = "";
  }

/* 
  * Chaque seconde la variable progress s'incrémente pour arriver à la valeur 1. 
  * Selon les secondes, un switch case va permettre de lancer les requête vers l'API OpenWeatherMap
  * et récupérer les données dans mapCities 
*/
  void searchWeatherTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(oneSec, (timer) {
      if (timer.tick >= 60 && progress >= 1) {
        setState(() {
          progress = 1;
          isAchieved = true;
          timer.cancel();
        });
      } else {
        setState(() {
          progress = progress + 1 / 60;

          switch (timer.tick) {
            case 10:
              ServiceApi().getWeather(cities[0], mapCities);
              currentMsg = loadingMessages[0];
              break;
            case 20:
              ServiceApi().getWeather(cities[1], mapCities);
              break;
            case 30:
              ServiceApi().getWeather(cities[2], mapCities);
              currentMsg = loadingMessages[1];
              break;
            case 40:
              ServiceApi().getWeather(cities[3], mapCities);
              break;
            case 50:
              ServiceApi().getWeather(cities[4], mapCities);
              currentMsg = loadingMessages[2];
              break;
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    progress = 0;
    isAchieved = false;
    currentMsg = "";
    searchWeatherTimer();
    resetMapCities();
  }

  @override
  void dispose() {
    _timer.cancel();
    isAchieved = false;
    currentMsg = "";
    resetMapCities();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(12, 26),
                        blurRadius: 50,
                        spreadRadius: 0,
                        color: Colors.grey.withOpacity(.25)),
                  ]),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 173, 112, 223),
                ),
                onPressed: () => Navigator.of(context).pop(),
              )),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/backgrounds%2Fdave-hoefler-PEkfSAxeplg-unsplash.jpg?alt=media&token=8b7e1d44-a52f-49f9-a3ae-e542cca0f368"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, bottom: 3, top: 3),
              child: Visibility(
                visible: true,
                child: Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 90.0,
                      animation: false,
                      animationDuration: 1200,
                      lineWidth: 15.0,
                      percent: (progress > 1) ? 1 : progress,
                      footer: Padding(
                          padding: EdgeInsets.only(top: 18.0),
                          child: (!isAchieved)
                              ? showLoadingText(currentMsg)
                              : TextButton(
                                  onPressed: () {
                                    setState(() {
                                      progress = 0;
                                      isAchieved = false;
                                      currentMsg = "";
                                      searchWeatherTimer();
                                      resetMapCities();
                                    });
                                  },
                                  child: Text(
                                    "Recommencer",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24.0,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ))),
                      center: Text(
                        "${(progress * 100).toStringAsFixed(2)} %",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.butt,
                      backgroundColor: Colors.white,
                      progressColor: const Color.fromARGB(255, 173, 112, 223),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Visibility(
                      visible: isAchieved,
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          tileWeather(context, "Rennes", mapCities),
                          tileWeather(context, "Paris", mapCities),
                          tileWeather(context, "Nantes", mapCities),
                          tileWeather(context, "Bordeaux", mapCities),
                          tileWeather(context, "Lyon", mapCities),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

/* 
* Widget qui s'adapte en fonction de l'état du chargement des données
*/
Text showLoadingText(String message) {
  return Text(
    message,
    textAlign: TextAlign.center,
    style: TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
  );
}

/* 
* /List tile utilisée pour afficher les données
*/
Widget tileWeather(
    BuildContext context, String city, Map<String, dynamic> map) {
  return Padding(
    padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
    child: SizedBox(
      height: 80,
      child: Card(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        elevation: 4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            city,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Text(
            " ${map[city]["temperature"].toString()} °C",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            // Fonction issue du package intl pour mettre une majuscule à la première lettre de la string
            toBeginningOfSentenceCase(map[city]["description"].toString()),
            style: const TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400),
          ),
        ]),
      ),
    ),
  );
}
