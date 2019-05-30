import '../src//screens/splashscreen.dart';

import '../src/widgets/drawer.dart';

import '../src/screens/display_data.dart';
import 'package:flutter/material.dart';

class App  extends StatefulWidget {
  App({Key key}) : super(key: key);
@override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.redAccent,
        fontFamily: 'Oswald',
        ),
      title: "Chroniques.sn",
      home: CustomSplashScreen(),
    //  DisplayData(),
    );
   
  }
}
