import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:calculator/button_panel/animations.dart';

//Style
const double _buttonFontSize = 16;
const Color _buttonColor = Color(0xFFFF8800);

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

  CalcButton({Key? key, String? label, IconData? iconData}) : super(key: key) {
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
      //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
    );
    ;
  }
}
