import 'package:flutter/material.dart';

import 'fb_demo.dart';
import 'home_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FB ADS',
      home: HomePageView(),
    );
  }
}
