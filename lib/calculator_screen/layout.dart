import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventify/eventify.dart';

///Used to display actions from @ButtonPanel
// ignore: must_be_immutable
class CalculatorScreen extends StatefulWidget {
  CalculatorScreen({Key? key}) : super(key: key);

  var _display = "\n0"; //current displayed value
  final _eventEmitter = EventEmitter();

  void setDisplay(String newValue) {
    _display = newValue;
    _eventEmitter.emit("update", null, ""); //signal to update state
  }

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    //Update state when needed
    widget._eventEmitter.on("update", null, (event, eventContext) {
      setState(() {});
    });

    return Column(
      children: [
        Container(
          child: Text(widget._display,
              style: const TextStyle(fontSize: 32, fontFeatures: [
                FontFeature
                    .tabularFigures() //for monospace font (but doesnt work... yet!)
              ])),
          alignment: Alignment.topRight,
        ),
      ],
    );
  }
}
