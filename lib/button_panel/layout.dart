import 'package:calculator/calculator_screen/layout.dart';
import 'package:calculator/logic/operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calculator/button_panel/button.dart';
import 'package:calculator/button_panel/animations.dart';

///Panel with calculator buttons. Displays actions on [screen]
class ButtonPanel extends StatefulWidget {
  late final OperationsQueue queue;
  late final List<Widget> buttonList;

  ButtonPanel({Key? key, required CalculatorScreen screen}) : super(key: key) {
    queue = OperationsQueue(screen);

    buttonList = [
      // AC
      CalcButton(
        label: "AC",
        onPressed: queue.clearAll,
      ),

      // Backspace
      CalcButton(
        iconData: const IconData(0xe0c5,
            fontFamily: 'MaterialIcons', matchTextDirection: true),
        onPressed: queue.removeLast,
      ),

      // Sqrt √
      CalcButton(
        label: "√",
        onPressed: () => queue.add(
          oneArgOperation: OperationElement.SQRT,
        ),
      ),

      // Division ÷
      CalcButton(
        label: "÷",
        onPressed: () => queue.add(twoArgOperation: OperationElement.DIVIDE),
      ),

      // 7-9
      for (var i = 7; i <= 9; i++)
        CalcButton(
          label: i.toString(),
          onPressed: () => queue.add(digit: i.toString()),
        ),

      // Multiplication *
      CalcButton(
        label: "×",
        onPressed: () => queue.add(twoArgOperation: OperationElement.MULTIPLY),
      ),

      // 4-6
      for (var i = 4; i <= 6; i++)
        CalcButton(
          label: i.toString(),
          onPressed: () => queue.add(digit: i.toString()),
        ),

      // Minus -
      CalcButton(
        label: "-",
        onPressed: () => queue.add(twoArgOperation: OperationElement.SUBTRACT),
      ),

      // 1-3
      for (var i = 1; i <= 3; i++)
        CalcButton(
          label: i.toString(),
          onPressed: () => queue.add(digit: i.toString()),
        ),

      // Sum +
      CalcButton(
        label: "+",
        onPressed: () => queue.add(twoArgOperation: OperationElement.SUM),
      ),

      // Inverse sign ±
      CalcButton(label: "±", onPressed: queue.inverseSign),
      CalcButton(
        label: "0",
        onPressed: () => queue.add(digit: '0'),
      ),

      // Coma ,
      CalcButton(
        label: ",",
        onPressed: queue.addComa,
      ),
      CalcButton(
        label: "=",
        onPressed: queue.result,
      ),
    ];
  }

  @override
  ButtonPanelState createState() => ButtonPanelState();
}

class ButtonPanelState extends State<ButtonPanel>
    with SingleTickerProviderStateMixin {
  late PanelAnimation panelAnimation; //for zoom in effect

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
    return SizedBox(
      child: Transform.scale(
        scale: panelAnimation.animation.value,
        child: GridView.count(
          crossAxisCount: 4,
          primary: false,
          children: widget.buttonList,
        ),
      ),
      height: 500,
      width: 500,
    );
  }
}
