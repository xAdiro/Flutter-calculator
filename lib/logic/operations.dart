import 'dart:math';

import 'package:calculator/calculator_screen/layout.dart';
import 'package:flutter/cupertino.dart';

class OperationsQueue {
  List<CalculationElement?> _queue = List.filled(16, null);
  double lastValue = 0;
  CalculatorScreen screen;

  OperationsQueue(this.screen) {
    _queue[0] = CalculationElement(number: 0);
  }

  void add(
      {double? digit,
      Function(double)? oneArgOperation,
      Function(double, double)? twoArgOperation}) {
    for (var i = 1; i < _queue.length; i++) {
      if (_queue[i] == null) {
        //
        if (digit != null) {
          if (_queue[i - 1]!.twoArgOperation == null) {
            _queue[i - 1]!.number = _queue[i - 1]!.number! * 10;
            _queue[i - 1]!.number = _queue[i - 1]!.number! + digit;
          } else {
            _queue[i]!.number = digit;
          }
        }
        //
        else if (oneArgOperation != null) {
          if (_queue[i - 1]!.twoArgOperation == null) {
            _queue[i - 1]!.oneArgOperation = oneArgOperation;
          } else {
            _queue[i]!.oneArgOperation = oneArgOperation;
          }
        }
        //
        else if (twoArgOperation != null) {
          _queue[i - 1]!.twoArgOperation = twoArgOperation;
          if (_queue[i - 1]!.number == null) _queue[i] = null;
        }
        break;
      }
    }
    _display();
  }

  void removeLast() {
    for (var i = _queue.length; i >= 0; i--) {
      if (_queue[i] != null) {
        _queue[i] = null;
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
    _queue = List.filled(16, null);
  }

  void _display() {
    String output = "";
    for (var i in _queue) {
      if (i == null) break;
      output += i.toString();
    }
    screen.setDisplay(output);
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
