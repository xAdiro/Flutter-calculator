import 'package:calculator/button_panel/layout.dart';
import 'package:calculator/calculator_screen/layout.dart';
import 'package:flutter/material.dart';

/*

USE DECIMAL IN FUTURE
*/
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screen = CalculatorScreen();

    //Navigator.push(context, MaterialPageRoute(builder: (_) => screen));

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        body: Column(
          children: [
            screen,
            ButtonPanel(screen: screen),
          ],
        ),
      ),
    );
  }
}
