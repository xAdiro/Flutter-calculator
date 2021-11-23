import 'dart:math';
import 'package:decimal/decimal.dart';

///Made to create queue of operations to perform. Structure: [oneArgOperation], [number], [twoArgOperation] e.g. √4+
class OperationElement {
  Function(Decimal)? oneArgOperation;
  Function(Decimal, Decimal)? twoArgOperation;
  String? number;
  OperationElement({this.number, this.oneArgOperation, this.twoArgOperation});

  @override
  String toString() {
    String output = "";

    switch (oneArgOperation) {
      case SQRT:
        output += "√";
    }

    //display only 6 decimals
    if (number != null) {
      output += number!;
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
}
