import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventify/eventify.dart';

///Used to display actions from @ButtonPanel
class CalculatorScreen extends StatefulWidget {
  CalculatorScreen({Key? key}) : super(key: key);

  //var _display = "0";
  final _lines = [CalcField('0')]; //current displayed value
  final _eventEmitter = EventEmitter();

  void setDisplay(String newValue) {
    _lines[0] = CalcField(newValue);
    _eventEmitter.emit("update", null, ""); //signal to update state
  }

  void newLine(String newValue) {
    _lines[0] = CalcField(_lines[0].text + "=");
    _lines.insert(0, CalcField(newValue));
    _lines.insert(0, CalcField(newValue));
    _eventEmitter.emit("update", null, ""); //start writing new line
  }

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    //Update state when needed
    widget._eventEmitter.on("update", null, (event, eventContext) {
      setState(() {});
    });

    return SizedBox(
      child: ListView(
        children: [for (var i in widget._lines.reversed) i],
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
      ),
      height: 200,
    );
  }
}

class CalcField extends StatelessWidget {
  final String text;

  const CalcField(this.text, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 40,
        ),
      ),
      alignment: Alignment.topRight,
    );
  }
}
