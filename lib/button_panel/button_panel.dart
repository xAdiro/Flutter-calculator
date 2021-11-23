import 'package:calculator/calculator_screen/calculator_screen.dart';
import 'package:calculator/logic/operations.dart';
import 'package:calculator/logic/operation_element.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'button.dart';
import 'animations.dart';

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
        funcButton: true,
      ),

      // Backspace
      CalcButton(
        iconData: const IconData(0xe0c5,
            fontFamily: 'MaterialIcons', matchTextDirection: true),
        onPressed: queue.removeLast,
        funcButton: true,
      ),

      // Sqrt √
      CalcButton(
        label: "√",
        onPressed: () => queue.add(
          oneArgOperation: OperationElement.SQRT,
        ),
        funcButton: true,
      ),

      // Division ÷
      CalcButton(
        label: "÷",
        onPressed: () => queue.add(twoArgOperation: OperationElement.DIVIDE),
        funcButton: true,
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
        funcButton: true,
      ),

      // 4-6
      for (var i = 4; i <= 6; i++)
        CalcButton(
          label: i.toString(),
          onPressed: () => queue.add(digit: i.toString()),
        ),

      // Minus −
      CalcButton(
        label: "−",
        onPressed: () => queue.add(twoArgOperation: OperationElement.SUBTRACT),
        funcButton: true,
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
        funcButton: true,
      ),

      // Inverse sign ±
      CalcButton(
        label: "±",
        onPressed: queue.inverseSign,
        funcButton: true,
      ),
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
        equalsButton: true,
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
    return Transform.scale(
      scale: panelAnimation.animation.value,
      child: GridView.count(
        crossAxisCount: 4,
        primary: false,
        children: widget.buttonList,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(0),
      ),
    );
  }
}
