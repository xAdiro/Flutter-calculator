import 'package:calculator/calculator_screen/layout.dart';
import 'package:calculator/logic/operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calculator/button_panel/content.dart';
import 'package:calculator/button_panel/animations.dart';

class ButtonPanel extends StatefulWidget {
  ButtonPanel({Key? key, required CalculatorScreen screen}) : super(key: key) {
    queue = OperationsQueue(screen);

    buttonList = [
      CalcButton(label: "AC"),
      CalcButton(
          iconData: const IconData(0xe0c5,
              fontFamily: 'MaterialIcons', matchTextDirection: true)),
      CalcButton(label: "√"),
      CalcButton(label: "÷"),
      for (var i = 7; i <= 9; i++)
        CalcButton(
          label: i.toString(),
          onPressed: () => queue.add(digit: i.toDouble()),
        ),
      CalcButton(label: "×"),
      for (var i = 4; i <= 6; i++)
        CalcButton(
          label: i.toString(),
          onPressed: () => queue.add(digit: i.toDouble()),
        ),
      CalcButton(label: "-"),
      for (var i = 1; i <= 3; i++)
        CalcButton(
          label: i.toString(),
          onPressed: () => queue.add(digit: i.toDouble()),
        ),
      CalcButton(
        label: "+",
        onPressed: () => queue.add(digit: 3),
      ),
      CalcButton(
          label: "±",
          onPressed: () {
            queue.screen.setDisplay("newValue");
          }),
      CalcButton(label: "0"),
      CalcButton(label: ","),
      CalcButton(label: "="),
    ];
  }

  late OperationsQueue queue;
  late List<Widget> buttonList;

  @override
  ButtonPanelState createState() => ButtonPanelState();
}

class ButtonPanelState extends State<ButtonPanel>
    with SingleTickerProviderStateMixin {
  late PanelAnimation panelAnimation;

  @override
  void initState() {
    super.initState();

    panelAnimation = PanelAnimation(this);
    panelAnimation.animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    panelAnimation.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Transform.scale(
        scale: panelAnimation.animation.value,
        child: GridView.count(
          crossAxisCount: 4,
          primary: false,
          children: widget.buttonList, //buttonList
        ),
      ),
      height: 500,
      width: 500,
    );
  }
}
