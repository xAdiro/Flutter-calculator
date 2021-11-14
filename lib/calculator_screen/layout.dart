import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventify/eventify.dart';

// ignore: must_be_immutable
class CalculatorScreen extends StatefulWidget {
  CalculatorScreen({Key? key}) : super(key: key);

  var _display = "0";
  final _eventEmitter = EventEmitter();

  void setDisplay(String newValue) {
    _display = newValue;
    _eventEmitter.emit("update", null, "");
  }

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    widget._eventEmitter.on("update", null, (event, eventContext) {
      setState(() {});
    });

    return Column(
      children: [
        Container(
          child: Text(widget._display, style: const TextStyle(fontSize: 32)),
          alignment: Alignment.topRight,
        ),
      ],
    );
  }
}
