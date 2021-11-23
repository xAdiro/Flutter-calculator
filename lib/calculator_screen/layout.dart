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
    _controller.jumpTo(_controller.position.minScrollExtent);
    _history[0].update(newValue);
  }

  void newLine(String newValue) {
    _controller.jumpTo(_controller.position.minScrollExtent);
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

          if (index >= 3) _history[index].disposeState();

          return _history[index];
        },
        reverse: true,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0),
        controller: _controller,
      ),
      height: 250,
    );
  }
}

// ignore: must_be_immutable
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

  void disposeState() {
    toDispose = true;
    _event.emit("dispose", null, "");
  }

  bool toDispose = false;

  @override
  _CalcFieldState createState() => _CalcFieldState();
}

class _CalcFieldState extends State<HistoryField>
    with AutomaticKeepAliveClientMixin<HistoryField> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    //update state when needed
    widget._event.on("update", null, (event, eventContext) {
      if (mounted) setState(() {});
    });

    //dispose when needed
    widget._event.on("dispose", null, (event, eventContext) {
      updateKeepAlive();
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

  @override
  bool get wantKeepAlive => !widget.toDispose;
}
