import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class calcScreenAnimation {
  calcScreenAnimation(SingleTickerProviderStateMixin screen) {
    controller = AnimationController(
        vsync: screen, duration: const Duration(milliseconds: 500));
    _curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(_curve);
    controller.forward();
  }

  late AnimationController controller;
  late Animation<double> animation;
  late CurvedAnimation _curve;
}
