import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class PanelAnimation {
  PanelAnimation(SingleTickerProviderStateMixin panel) {
    controller = AnimationController(
        vsync: panel, duration: const Duration(milliseconds: 500));
    _curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );
    animation = Tween<double>(begin: 100, end: 1).animate(_curve)
          ..addListener(() {})

        //padding in grid
        /*..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          })*/
        ;
    controller.forward();
  }

  late AnimationController controller;
  late Animation<double> animation;
  late CurvedAnimation _curve;
}
