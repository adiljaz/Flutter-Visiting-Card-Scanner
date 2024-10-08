import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zikrabyte/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VisiScan Pro',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        focusColor: Colors.amberAccent,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16.0),
        ),
      ),
      home: HomePage(),
    );
  }
}
