import 'dart:math';

class ResultElement {
  Function(double) operation;
  late double number;
  ResultElement(this.number, this.operation);

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
}
