import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//Style
const double _buttonFontSize = 25;
const Color _buttonColor = Color(0xFF000000);
const Color _funcButtonColor = Color(0xFF3f38ff);
const Color _buttonBorderColor = Color(0xFFC9C9C9);

class CalcButton extends StatelessWidget {
  ///icon or text depending on constructor input
  late final Widget _child;
  final Function()? onPressed;
  final bool equalsButton;

  ///Create button with icon or text and action [onPressed]. Prioritizes [label] over [iconData]
  CalcButton(
      {Key? key,
      String? label,
      IconData? iconData,
      required this.onPressed,
      bool funcButton = false,
      this.equalsButton = false})
      : super(key: key) {
    //if label given
    if (label != null) {
      _child = Text(
        label,
        style: TextStyle(
          fontSize: _buttonFontSize,
          color: funcButton
              ? _funcButtonColor
              : equalsButton
                  ? Colors.white
                  : _buttonColor,
        ),
      );
    }
    //if icon given
    else if (iconData != null) {
      _child = Icon(
        iconData,
        size: _buttonFontSize,
        color: funcButton
            ? _funcButtonColor
            : equalsButton
                ? Colors.white
                : _buttonColor,
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
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: const BorderSide(color: _buttonBorderColor),
            ),
          ),
          backgroundColor: equalsButton
              ? MaterialStateProperty.all<Color>(_funcButtonColor)
              : MaterialStateProperty.all<Color>(Colors.white),
        ),
      ),
      margin: const EdgeInsets.all(3),
    );
  }
}
