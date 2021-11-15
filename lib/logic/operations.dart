import 'dart:math';
import 'package:calculator/calculator_screen/layout.dart';
import 'package:decimal/decimal.dart';

class OperationsQueue {
  List<OperationElement?> _queue = List.filled(16, null);
  List<OperationElement?> _lastState = List.filled(16, null);
  CalculatorScreen screen;

  OperationsQueue(this.screen) {
    _queue[0] = OperationElement(number: '0');
  }

  void add({
    String? digit,
    Function(Decimal)? oneArgOperation,
    Function(Decimal, Decimal)? twoArgOperation,
  }) {
    for (var i = 1; i < _queue.length; i++) {
      if (_queue[i] == null) {
        //
        if (digit != null) {
          //if there is already number add to it next digit
          if (_queue[i - 1]!.twoArgOperation == null) {
            //remove 0s before number
            if (_queue[i - 1]!.number == '0') {
              _queue[i - 1]!.number = "";
            }

            _queue[i - 1]!.number = _queue[i - 1]!.number! + digit;
          }
          //else add new number equals to digit
          else {
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

  void inverseSign() {
    // put "-" before first number
    _queue[0]!.number = Decimal.parse("-" + _queue[0]!.number!).toString();

    // put "-" for the rest

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
        i.number ??= '0';
        i.number = i.oneArgOperation!(Decimal.parse(i.number!)).toString();
        i.oneArgOperation = null;
      }
    }

    //start with 0
    Decimal result = Decimal.parse(_queue[0]!.number!);

    for (var i = 0; i < _queue.length - 1 && _queue[i] != null; i++) {
      //Mult, divide

      var qi = _queue[i];
      var qi1 = _queue[i + 1];

      if (qi!.twoArgOperation == OperationElement.MULTIPLY ||
          qi.twoArgOperation == OperationElement.DIVIDE) {
        _queue[i + 1]!.number = qi.twoArgOperation!
                (Decimal.parse(qi.number!), Decimal.parse(qi1!.number!))
            .toString();
        _queue[i] = OperationElement(
            number: '0', twoArgOperation: OperationElement.SUM);
      }
    }

    for (var i = 0; i < _queue.length - 1; i++) {
      var qi = _queue[i];
      var qi1 = _queue[i + 1];
      //if end of queue reached the result is calculated
      if (qi == null) {
        result = Decimal.parse(_queue[i - 1]!.number!);
        break;
      }
      //Sum, subtract
      if (qi.twoArgOperation == OperationElement.SUM ||
          qi.twoArgOperation == OperationElement.SUBTRACT) {
        _queue[i + 1]!.number = _queue[i]!
            .twoArgOperation!
                (Decimal.parse(qi.number!), Decimal.parse(qi1!.number!))
            .toString();
      }
    }

    _clear();
    _queue[0] = OperationElement(number: result.toString());
    _display();
  }

  void removeLast() {
    for (var i = _queue.length - 1; i >= 0; i--) {
      // 54 + --> 54
      if (_queue[i] != null) {
        if (_queue[i]!.twoArgOperation != null) {
          _queue[i]!.twoArgOperation = null;
        }
        //  54 --> 5
        else if (_queue[i]!.number != null) {
          //remove last digit
          _queue[i]!.number =
              _queue[i]!.number!.substring(0, _queue[i]!.number!.length - 1);
          //if there is no number make it null
          if (_queue[i]!.number == "") _queue[i]!.number = null;
          break;
        }
        // 54 + √ --> 54 +
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
    _queue[0] = OperationElement(number: '0');
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
  Function(Decimal)? oneArgOperation;
  Function(Decimal, Decimal)? twoArgOperation;
  String? number;
  OperationElement({this.number, this.oneArgOperation, this.twoArgOperation});

  // ignore: non_constant_identifier_names
  static Decimal SUM(Decimal a, Decimal b) {
    return a + b;
  }

  // ignore: non_constant_identifier_names
  static Decimal SUBTRACT(Decimal a, Decimal b) {
    return a - b;
  }

  // ignore: non_constant_identifier_names
  static Decimal MULTIPLY(Decimal a, Decimal b) {
    return a * b;
  }

  // ignore: non_constant_identifier_names
  static Decimal DIVIDE(Decimal a, Decimal b) {
    return a / b;
  }

  // ignore: non_constant_identifier_names
  static Decimal SQRT(Decimal a) {
    return Decimal.parse(sqrt(a.toDouble()).toString());
  }

  @override
  String toString() {
    String output = "";

    switch (oneArgOperation) {
      case SQRT:
        output += "√";
    }

    if (number != null) {
      output += number!;
      //number! % 1 == 0 ? number!.toInt().toString() : number.toString();
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
