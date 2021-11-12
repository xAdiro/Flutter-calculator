import 'dart:math';

import 'package:calculator/operations_screen/layout.dart';
import 'package:flutter/cupertino.dart';

class OperationsQueue {
  List<CalculationElement?> queue = List.filled(16, null);
  double lastValue = 0;
  GlobalKey<CalculatorScreenState> screen;

  OperationsQueue(this.screen);

  void add(
      {double? digit,
      Function(double)? oneArgOperation,
      Function(double, double)? twoArgOperation}) {
    for (var i = 1; i < queue.length; i++) {
      if (queue[i] == null) {
        //
        if (digit != null) {
          if (queue[i - 1]!.twoArgOperation == null) {
            queue[i - 1]!.number = queue[i - 1]!.number! * 10;
            queue[i - 1]!.number = queue[i - 1]!.number! + digit;
          } else {
            queue[i]!.number = digit;
          }
        }
        //
        else if (oneArgOperation != null) {
          if (queue[i - 1]!.twoArgOperation == null) {
            queue[i - 1]!.oneArgOperation = oneArgOperation;
          } else {
            queue[i]!.oneArgOperation = oneArgOperation;
          }
        }
        //
        else if (twoArgOperation != null) {
          queue[i - 1]!.twoArgOperation = twoArgOperation;
          if (queue[i - 1]!.number == null) queue[i] = null;
        }
        break;
      }
    }
    _display();
  }

  void removeLast() {
    for (var i = queue.length; i >= 0; i--) {
      if (queue[i] != null) {
        queue[i] = null;
        break;
      }
    }
  }

  void clearAll() {
    _clear();
    //add();
    _display();
  }

  void _clear() {
    queue = List.filled(16, null);
  }

  void _display() {
    String output = "";
    for (var i in queue) {
      output += i!.number.toString() + i.toString();
    }
    screen.currentState!.output = output;
  }
}

class CalculationElement {
  Function(double)? oneArgOperation;
  Function(double, double)? twoArgOperation;
  double? number;

  CalculationElement({this.number, this.oneArgOperation, this.twoArgOperation});

  // ignore: non_constant_identifier_names
  static double SUM(double a, double b) {
    return a + b;
  }

  // ignore: non_constant_identifier_names
  static double SUBTRACT(double a, double b) {
    return a - b;
  }

  // ignore: non_constant_identifier_names
  static double MULTIPLY(double a, double b) {
    return a * b;
  }

  // ignore: non_constant_identifier_names
  static double DIVIDE(double a, double b) {
    return a / b;
  }

  // ignore: non_constant_identifier_names
  static double SQRT(double a) {
    return sqrt(a);
  }

  @override
  String toString() {
    String output = "";

    switch (oneArgOperation) {
      case SQRT:
        output += "√";
    }
    output += number.toString();

    switch (twoArgOperation) {
      case SUM:
        output += "+";
        break;
      case SUBTRACT:
        output += "-";
        break;
      case MULTIPLY:
        output += "×";
        break;
      case DIVIDE:
        output += "÷";
        break;
    }

    return output;
  }
}
