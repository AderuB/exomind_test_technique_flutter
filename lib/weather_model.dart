// classe Weather pour décoder le json et récupérer les données demandées (température et description)
class Weather {
  String main;
  String description;
  // ignore: prefer_typing_uninitialized_variables
  var temp;

  Weather(Map map) {
    List weather = map["weather"];
    Map weatherMap = weather.first;
    main = weatherMap["main"];
    description = weatherMap["description"];
    Map mainMap = map["main"];
    temp = mainMap["temp"];
  }
}
