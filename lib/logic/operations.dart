import 'dart:math';
import 'package:calculator/calculator_screen/layout.dart';
import 'package:decimal/decimal.dart';
import 'dart:developer' as dev;

class OperationsQueue {
  ///Contains list of operations and numbers to which perform them on
  List<OperationElement?> _queue = List.filled(16, null);
  List<OperationElement?> _lastState = List.filled(16, null);
  CalculatorScreen screen;

  OperationsQueue(this.screen) {
    _queue[0] = OperationElement(number: '0');
  }

  ///Adds [OperationElement] to [_queue]
  void add({
    String? digit,
    Function(Decimal)? oneArgOperation,
    Function(Decimal, Decimal)? twoArgOperation,
  }) {
    for (var i = 1; i < _queue.length; i++) {
      if (_queue[i] == null) {
        //NUMBER
        if (digit != null) {
          //if there is already number add to it next digit
          if (_queue[i - 1]!.twoArgOperation == null) {
            //remove 0s before number
            if (_queue[i - 1]!.number == '0') {
              _queue[i - 1]!.number = "";
            }

            if (_queue[i - 1]!.number == null) {
              _queue[i - 1]!.number = digit;
            } else {
              _queue[i - 1]!.number = _queue[i - 1]!.number! + digit;
            }
          }
          //else add new number equals to digit
          else {
            _queue[i] = OperationElement(number: digit);
          }
        }
        //ONEARGOPERATION
        else if (oneArgOperation != null) {
          if (_queue[i - 1]!.twoArgOperation == null) {
            if (i == 1 && _queue[0]!.number == '0') {
              _queue[i - 1]!.number = null;
              _queue[i - 1] =
                  OperationElement(oneArgOperation: oneArgOperation);
              break;
            } else {
              _queue[i - 1]!.twoArgOperation = OperationElement.MULTIPLY;
              _queue[i - 1]!.number ??= '0';
            }
          }
          _queue[i] = OperationElement(oneArgOperation: oneArgOperation);
        }
        //TWOARGOPERATION
        else if (twoArgOperation != null && _queue[i - 1]!.number != null) {
          if (_queue[i - 1]!.number!.endsWith(".")) {
            _queue[i - 1]!.number =
                _queue[i - 1]!.number!.replaceAll(RegExp(r"\."), "");
            dev.log("jhu");
          }
          _queue[i - 1]!.twoArgOperation = twoArgOperation;
          if (_queue[i - 1]!.number == null) _queue[i] = null;
        }
        break;
      }
    }

    _display();
  }

  ///Adds coma to type in decimals
  void addComa() {
    for (var i = _queue.length - 1; i >= 0; i--) {
      if (_queue[i] != null) {
        _queue[i]!.number ??= "0";
        _queue[i]!.number = _queue[i]!.number! + ".";

        //If there is second coma delete it
        try {
          Decimal.parse(_queue[i]!.number!);
        } catch (e) {
          _queue[i]!.number =
              _queue[i]!.number!.substring(0, _queue[i]!.number!.length - 1);
        }
        _display();

        break;
      }
    }
  }

  ///Inverses sign of numbers in [_queue]
  void inverseSign() {
    // put "-" before first number
    _queue[0]!.number = (-Decimal.parse(_queue[0]!.number!)).toString();

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

  ///Displays the result of [_queue] on [screen] then sets [_queue] to default (0)
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
    Decimal result;
    try {
      result = Decimal.parse(_queue[0]!.number!);
    } catch (e) {
      result = Decimal.zero;
      _queue[0]!.number = '0';
    }

    for (var i = 0; i < _queue.length - 1 && _queue[i] != null; i++) {
      //Mult, divide

      var qi = _queue[i];
      var qi1 = _queue[i + 1];

      if (qi!.twoArgOperation == OperationElement.MULTIPLY ||
          qi.twoArgOperation == OperationElement.DIVIDE) {
        try {
          _queue[i + 1]!.number = qi.twoArgOperation!
                  (Decimal.parse(qi.number!), Decimal.parse(qi1!.number!))
              .toString();
        } catch (e) {
          _clear();
          _queue[0] = OperationElement(number: '0');
          _display(text: "Błąd");
          return;
        }

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

  ///Removes last character
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

          //first field can't be empty
          if (_queue[0]!.number == "") _queue[0]!.number = '0';
          //if there is no number, and it's not first delete element
          if (_queue[i]!.number == "") _queue[i] = null;
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
        _queue[0] ??= OperationElement(number: '0');
        break;
      }
    }
    _display();
  }

  ///Sets [_queue] to default (0)
  void clearAll() {
    _clear();
    _queue[0] = OperationElement(number: '0');
    _display();
  }

  ///Clears [_queue]
  void _clear() {
    _queue = List.filled(16, null);
  }

  ///Display current [_queue] on [screen]
  void _display({String? text}) {
    if (text != null) {
      screen.setDisplay(text);
      return;
    }
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
        } else {
          //cant have plus/minsu/div/mult null

          _queue[i]!.twoArgOperation = null;
        }

        return;
      }
    }
  }
}

///Made to create queue of operations to perform. Structure: [oneArgOperation], [number], [twoArgOperation] e.g. √4+
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
        output += "−";
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
