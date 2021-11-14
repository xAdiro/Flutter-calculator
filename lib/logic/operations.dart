import 'dart:math';

import 'package:calculator/calculator_screen/layout.dart';

class OperationsQueue {
  List<OperationElement?> _queue = List.filled(16, null);
  double lastValue = 0;
  CalculatorScreen screen;

  OperationsQueue(this.screen) {
    _queue[0] = OperationElement(number: 0);
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
            _queue[i] = OperationElement(number: digit);
          }
        }
        //
        else if (oneArgOperation != null) {
          if (_queue[i - 1]!.twoArgOperation == null) {
            _queue[i - 1]!.oneArgOperation = oneArgOperation;
          } else {
            _queue[i - 1]!.twoArgOperation == null;
            _queue[i - 1]!.oneArgOperation = oneArgOperation;
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

  void result() {}

  void removeLast() {
    for (var i = _queue.length - 1; i >= 0; i--) {
      if (_queue[i] != null) {
        if (_queue[i]!.twoArgOperation != null) {
          _queue[i]!.twoArgOperation = null;
        }
        //
        else if (_queue[i]!.number != null) {
          _queue[i]!.number = (_queue[i]!.number! ~/ 10).toDouble();

          // if (_queue[i]!.number != _queue[i]!.number!.toInt().toDouble()) {
          //   _queue[i]!.number = 0;
          // }

          break;
        }
        //
        else if (_queue[i]!.oneArgOperation != null) {
          _queue[i] = null;
        }
        //
        else {
          _queue[i] = null;
          removeLast();
        }

        _queue[i] = null;
        break;
      }
    }
    _display();
  }

  void clearAll() {
    _clear();
    _queue[0] = OperationElement(number: 0);
    _display();
  }

  void _clear() {
    _queue = List.filled(16, null);
  }

  void _display() {
    String output = "\n";
    for (var i in _queue) {
      if (i == null) break;
      output += i.toString();
    }
    screen.setDisplay(output);
  }
}

class OperationElement {
  Function(double)? oneArgOperation;
  Function(double, double)? twoArgOperation;
  double? number;

  OperationElement({this.number, this.oneArgOperation, this.twoArgOperation});

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

    if (number != null) {
      output +=
          number! % 1 == 0 ? number!.toInt().toString() : number.toString();
    }

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
