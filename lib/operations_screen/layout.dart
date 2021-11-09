import 'package:flutter/cupertino.dart';
import 'package:calculator/button_panel/layout.dart';
import 'package:calculator/logic/operations.dart';

class OperationScreen extends StatefulWidget {
  @override
  _OperationScreenState createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  String output = "0";
  List<ResultElement?> operationsQueue = List<ResultElement?>.filled(16, null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(output, style: const TextStyle(fontSize: 32)),
      alignment: Alignment.topRight,
    );
  }
}
