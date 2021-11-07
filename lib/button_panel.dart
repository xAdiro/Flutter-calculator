import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonPanel extends StatelessWidget {
  const ButtonPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      primary: false,
      children: [for (var i in buttonList) _calcButton(i)],
    );
  }
}

AnimatedContainer _calcButton(Widget label) {
  return AnimatedContainer(
    duration: const Duration(seconds: 3),
    child: TextButton(
      onPressed: () {},
      child: label,
    ),
  );
}

List<Widget> buttonList = [
  Label("AC"),
  const Icon(
      IconData(0xe0c5, fontFamily: 'MaterialIcons', matchTextDirection: true)),
  Label("√"),
  Label("÷"),
  for (var i = 7; i <= 9; i++) Label(i.toString()),
  Label("×"),
  for (var i = 4; i <= 6; i++) Label(i.toString()),
  Label("-"),
  for (var i = 1; i <= 3; i++) Label(i.toString()),
  Label("+"),
  Label("±"),
  Label("0"),
  Label(","),
  Label("="),
];

Widget Label(String label) {
  return Text(
    label,
    style: const TextStyle(
      fontSize: 30,
    ),
  );
}
