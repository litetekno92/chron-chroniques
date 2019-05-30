import './src/resources/color.dart';
import 'package:flutter/services.dart';

import 'src/app.dart';
import 'package:flutter/material.dart';

void main() { 
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: CustomColor.mbluecol));
  runApp(App()); 
  }