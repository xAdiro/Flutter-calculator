import 'dart:math';
import 'package:calculator/calculator_screen/layout.dart';
import 'dart:developer' as dev;

class OperationsQueue {
  List<OperationElement?> _queue = List.filled(16, null);
  List<OperationElement?> _lastState = List.filled(16, null);
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

    if (_queue[_queue.length - 1] != null) {
      // Cant have operation for number outside of space
      _queue[_queue.length - 1]!.twoArgOperation = null;
    }
    _display();
  }

  void inverseSign() {
    _queue[0]!.number = -_queue[0]!.number!;

    for (var i in _queue) {
      if (i == null) break;

      if (i.twoArgOperation == OperationElement.SUM) {
        i.twoArgOperation = OperationElement.SUBTRACT;
      } else if (i.twoArgOperation == OperationElement.SUBTRACT) {
        i.twoArgOperation = OperationElement.SUM;
      }
    }

    _display();
  }

  void result() {
    _lastState = _queue;

    _removeEmptyOperation();

    for (var i in _queue) {
      //Square root
      if (i == null) break;

      if (i.oneArgOperation != null) {
        i.number ??= 0;
        i.number = i.oneArgOperation!(i.number!);
        i.oneArgOperation = null;
      }
    }

    double result = _queue[0]!.number!;

    for (var i = 0; i < _queue.length - 1 && _queue[i] != null; i++) {
      //Mult, divide
      if (_queue[i]!.twoArgOperation == OperationElement.MULTIPLY ||
          _queue[i]!.twoArgOperation == OperationElement.DIVIDE) {
        _queue[i + 1]!.number = _queue[i]!.twoArgOperation!(
            _queue[i]!.number!, _queue[i + 1]!.number!);
        _queue[i] =
            OperationElement(number: 0, twoArgOperation: OperationElement.SUM);
      }
    }

    for (var i = 0; i < _queue.length - 1; i++) {
      if (_queue[i] == null) {
        result = _queue[i - 1]!.number!;
        break;
      }
      //Sum, subtract
      if (_queue[i]!.twoArgOperation == OperationElement.SUM ||
          _queue[i]!.twoArgOperation == OperationElement.SUBTRACT) {
        _queue[i + 1]!.number = _queue[i]!.twoArgOperation!(
            _queue[i]!.number!, _queue[i + 1]!.number!);
      }
    }

    _clear();
    _queue[0] = OperationElement(number: result);
    _display();
  }

  void removeLast() {
    for (var i = _queue.length - 1; i >= 0; i--) {
      if (_queue[i] != null) {
        if (_queue[i]!.twoArgOperation != null) {
          _queue[i]!.twoArgOperation = null;
        }
        //
        else if (_queue[i]!.number != null) {
          _queue[i]!.number = (_queue[i]!.number! ~/ 10).toDouble();
          if (_queue[i]!.number == 0 && i != 0) _queue[i]!.number = null;
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

  ///Removes potential numberless operation from the end of queue
  void _removeEmptyOperation() {
    //DOESNT WORK!
    for (int i = _queue.length - 1; i >= 0; i--) {
      if (_queue[i] != null) {
        if (_queue[i]!.number == null && _queue[i]!.oneArgOperation != null) {
          // cant have sqrt of null

          _queue[i] = null;
        } else {
          //cant have plus/minsu/div/mult null

          _queue[i]!.twoArgOperation = null;
        }

        return;
      }
    }
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
