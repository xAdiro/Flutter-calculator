import 'package:calculator/calculator_screen/calculator_screen.dart';
import 'package:decimal/decimal.dart';
import 'operation_element.dart';

class OperationsQueue {
  ///Contains queue of operations and numbers to which perform them on
  List<OperationElement?> _queue = List.filled(16, null);
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
          if (_queue[i - 1]!.twoArgOperation == null) {
            //remove 0s before number
            if (_queue[i - 1]!.number == '0') {
              _queue[i - 1]!.number = "";
            }
            //if number is empty place digit
            if (_queue[i - 1]!.number == null) {
              _queue[i - 1]!.number = digit;
            }
            //else add digit to existing one
            else {
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
    _removeEmptyOperation();

    for (var i in _queue) {
      //Square root
      if (i == null) break;

      if (i.oneArgOperation != null) {
        if (i.number == null) {
          _display(error: "Błąd");
          return;
        }

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

      var queCurr = _queue[i];
      var queNext = _queue[i + 1];

      if (queCurr!.twoArgOperation == OperationElement.MULTIPLY ||
          queCurr.twoArgOperation == OperationElement.DIVIDE) {
        try {
          _queue[i + 1]!.number = queCurr.twoArgOperation!(
                  Decimal.parse(queCurr.number!),
                  Decimal.parse(queNext!.number!))
              .toString();
        } catch (e) {
          _display(error: "Błąd");
          return;
        }

        _queue[i] = OperationElement(
            number: '0', twoArgOperation: OperationElement.SUM);
      }
    }

    for (var i = 0; i < _queue.length - 1; i++) {
      var queCurr = _queue[i];
      var queNext = _queue[i + 1];
      //if end of queue reached the result is calculated
      if (queCurr == null) {
        result = Decimal.parse(_queue[i - 1]!.number!);
        break;
      }
      //Sum, subtract
      if (queCurr.twoArgOperation == OperationElement.SUM ||
          queCurr.twoArgOperation == OperationElement.SUBTRACT) {
        _queue[i + 1]!.number = _queue[i]!
            .twoArgOperation!(
                Decimal.parse(queCurr.number!), Decimal.parse(queNext!.number!))
            .toString();
      }
    }

    _clear();
    _queue[0] = OperationElement(number: result.toString());
    screen.newLine(result.toString());
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
  void _display({String? text, String? error}) {
    if (error != null) {
      _clear();
      _queue[0] = OperationElement(number: '0');
      _display(text: "Błąd");
      return;
    }

    if (text != null) {
      screen.setDisplay(text);
      return;
    }
    String output = "";
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
