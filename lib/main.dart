import 'package:flutter/material.dart';
import 'package:test_flutter_exomind_benamara/screens/homepage_screen.dart';

/* 
* Main
*/
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
      home:  HomePageScreen(),
    );
  }
}



