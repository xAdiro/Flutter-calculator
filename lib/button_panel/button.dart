import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//Style
const double _buttonFontSize = 20;
const Color _buttonColor = Color(0xFFcf0000);
const Color _buttonBorderColor = Color(0xFFC9C9C9);

class CalcButton extends StatelessWidget {
  ///icon or text depending on constructor input
  late final Widget _child;
  final Function()? onPressed;

  ///Create button with icon or text and action [onPressed]. Prioritizes [label] over [iconData]
  CalcButton({Key? key, String? label, IconData? iconData, this.onPressed})
      : super(key: key) {
    //if label given
    if (label != null) {
      _child = Text(label,
          style:
              const TextStyle(fontSize: _buttonFontSize, color: _buttonColor));
    }
    //if icon given
    else if (iconData != null) {
      _child = Icon(
        iconData,
        size: _buttonFontSize,
        color: _buttonColor,
      );
    }
    //if none given
    else {
      throw Exception("Either label or iconData has to be set");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: _child,
        onPressed: onPressed,
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
