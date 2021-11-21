import 'package:calculator/button_panel/layout.dart';
import 'package:calculator/calculator_screen/layout.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screen = CalculatorScreen();

    return MaterialApp(
      title: 'Kalkulator',
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              screen,
              ButtonPanel(screen: screen),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ),
      ),
    );
  }
}
