import 'package:calculator/button_panel/button_panel.dart';
import 'package:calculator/calculator_screen/calculator_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator',
      home: Scaffold(
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          ///height of [Divider]
          const divH = 16;

          ///height of [ButtonPanel]
          final panelH = constraints.maxWidth * (5 / 4);

          ///height of [CalculatorScreen]
          final screenHeight = constraints.maxHeight - panelH - divH;
          final screen = CalculatorScreen(height: screenHeight);

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
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          );
        }),
      ),
    );
  }
}
