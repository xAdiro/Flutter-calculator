import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:calculator/button_panel/animations.dart';
import 'package:calculator/operations_screen/layout.dart';
import 'package:calculator/logic/operations.dart';

//Style
const double _buttonFontSize = 20;
const Color _buttonColor = Color(0xFFcf0000);
const Color _buttonBorderColor = Color(0xFFC9C9C9);

List<Widget> buttonList = [
  CalcButton(label: "AC"),
  CalcButton(
      iconData: const IconData(0xe0c5,
          fontFamily: 'MaterialIcons', matchTextDirection: true)),
  CalcButton(label: "√"),
  CalcButton(label: "÷"),
  for (var i = 7; i <= 9; i++) CalcButton(label: i.toString()),
  CalcButton(label: "×"),
  for (var i = 4; i <= 6; i++) CalcButton(label: i.toString()),
  CalcButton(label: "-"),
  for (var i = 1; i <= 3; i++) CalcButton(label: i.toString()),
  CalcButton(label: "+"),
  CalcButton(label: "±"),
  CalcButton(label: "0"),
  CalcButton(label: ","),
  CalcButton(label: "="),
];

class CalcButton extends StatelessWidget {
  late final Widget _child;

  CalcButton(
      {Key? key,
      String? label,
      IconData? iconData,
      OperationsQueue? operationsQueue})
      : super(key: key) {
    if (label != null) {
      _child = Text(label,
          style:
              const TextStyle(fontSize: _buttonFontSize, color: _buttonColor));
    } else if (iconData != null) {
      _child = Icon(
        iconData,
        size: _buttonFontSize,
        color: _buttonColor,
      );
    } else {
      throw Exception("Either label or iconData has to be set");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: _child,
        onPressed: () => {},
      ),
      decoration: BoxDecoration(
          border: Border.all(
            color: _buttonBorderColor,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      margin: const EdgeInsets.all(3),
    );
  }
}
