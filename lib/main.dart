import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zikrabyte/view/home.dart';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VisiScan Pro',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        focusColor: Colors.amberAccent,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16.0),
        ),
      ),
      home: HomePage(),
    );
  }
}
