import '../models/category_model.dart';
import '../widgets/drawer.dart';

import '../models/category_model.dart';
import '../resources/color.dart';
import '../screens/fetchdatacat.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class CustomSplashScreen extends StatelessWidget {
  final int category;
  final int page;
  CustomSplashScreen({this.category, this.page});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SplashScreen(
        seconds: 03,
        navigateAfterSeconds: new 
        CustomDrawer(),
        // FetchDataCat(
        //     category: categories[0].id, page: categories[0].page),
        title: new Text(
          'Bienvenue sur Chroniques.sn',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: CustomColor.mbluecol,)
        ),
        // image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
        image: Image.asset('images/chroniques_logo.png'),
        backgroundColor: CustomColor.mgreycol,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
    //    onClick: () => print("Flutter Egypt"),
        loaderColor: CustomColor.mbluecol);
  }
}
