import 'package:flutter/cupertino.dart';
import 'package:calculator/button_panel/layout.dart';
import 'package:calculator/logic/operations.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  var stateKey = GlobalKey<CalculatorScreenState>();
  late OperationsQueue operationsQueue;

  CalculatorScreen({Key? key}) : super(key: key) {
    if (key == null) {
      CalculatorScreen(key: stateKey);
      operationsQueue = OperationsQueue(stateKey);
    }
  }

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  String output = "\n0";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(output, style: const TextStyle(fontSize: 32)),
      alignment: Alignment.topRight,
    );
  }
}
