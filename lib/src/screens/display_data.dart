import '../widgets/appbar.dart';

import '../widgets/drawer.dart';

import 'package:flutter/material.dart';

final key = new GlobalKey<CustomDrawerState>();

class DisplayData extends StatefulWidget {
  DisplayData({Key key}) : super(key: key);

  _DisplayDataState createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(key: key),
      body: Center(child:Text('Hello')),
      appBar: CustomAppBar(key: key,),
    );
  }
}