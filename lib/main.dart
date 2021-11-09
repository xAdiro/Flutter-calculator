import 'package:calculator/button_panel/layout.dart';
import 'package:calculator/operations_screen/layout.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        body: Column(
          children: [OperationScreen(), const ButtonPanel()],
        ),
      ),
    );
  }
}
