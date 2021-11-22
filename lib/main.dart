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
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              screen,
              Divider(
                thickness: 0.5,
                color: Colors.black,
                indent: constraints.maxWidth * 0.01,
                endIndent: constraints.maxWidth * 0.01,
              ),
              ButtonPanel(
                screen: screen,
                width: constraints.maxWidth,
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
          );
        }),
      ),
    );
  }
}
