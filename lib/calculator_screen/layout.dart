import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventify/eventify.dart';

///Used to display actions from @ButtonPanel
class CalculatorScreen extends StatelessWidget {
  CalculatorScreen({Key? key}) : super(key: key);

  //var _display = "0";
  final _history = [HistoryField('0')]; //current displayed value
  final _historyKey = GlobalKey<AnimatedListState>();
  final _controller = ScrollController();

  void insert() {}

  void setDisplay(String newValue) {
    _history[0].update(newValue);
    _controller.jumpTo(_controller.position.minScrollExtent);
  }

  void newLine(String newValue) {
    _history[0].add("=");
    _history.insert(0, HistoryField(newValue));
    _historyKey.currentState!.insertItem(
      0,
      duration: const Duration(milliseconds: 150),
    );
    _history.insert(0, HistoryField(newValue));
    _historyKey.currentState!.insertItem(
      0,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AnimatedList(
        key: _historyKey,
        initialItemCount: 1,
        itemBuilder: (context, index, animation) {
          _history[index].animation = animation;

          return _history[index];
        },
        reverse: true,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0),
        controller: _controller,
      ),
      height: 200,
    );
  }
}

class HistoryField extends StatefulWidget {
  HistoryField(this.text, {Key? key}) : super(key: key);
  final _event = EventEmitter();
  late Animation<double> animation;
  late String text;

  void update(String text) {
    this.text = text;
    _event.emit("update", null, "");
  }

  void add(String text) {
    this.text += text;
    _event.emit("update", null, "");
  }

  @override
  _CalcFieldState createState() => _CalcFieldState();
}

class _CalcFieldState extends State<HistoryField> {
  @override
  Widget build(BuildContext context) {
    widget._event.on("update", null, (event, eventContext) {
      setState(() {});
    });

    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: widget.animation,
      child: Container(
        child: Text(
          widget.text,
          style: const TextStyle(
            fontSize: 40,
          ),
        ),
        alignment: Alignment.topRight,
      ),
    );
  }
}
