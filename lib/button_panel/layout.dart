import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calculator/button_panel/content.dart';
import 'package:calculator/button_panel/animations.dart';

class ButtonPanel extends StatefulWidget {
  const ButtonPanel({Key? key}) : super(key: key);

  @override
  _ButtonPanelState createState() => _ButtonPanelState();
}

class _ButtonPanelState extends State<ButtonPanel>
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
    return GridView.count(
      crossAxisCount: 4,
      primary: false,
      children: [for (var i in buttonList) i],
      padding: EdgeInsets.all(panelAnimation.animation.value),
    );
  }
}
