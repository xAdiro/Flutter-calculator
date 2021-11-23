import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventify/eventify.dart';

///Single line on a [CalculatorScreen]
// ignore: must_be_immutable
class HistoryField extends StatefulWidget {
  HistoryField(this.text, {Key? key, this.old = false}) : super(key: key);

  ///used to send notifications from [HistoryField] to its [State]
  final _event = EventEmitter();
  late Animation<double> animation;
  late String text;
  bool old;

  ///sets field as [text]
  void set(String text) {
    this.text = text;
    _event.emit("update", null, "");
  }

  ///add [text] to field
  void add(String text) {
    this.text += text;
    _event.emit("update", null, "");
  }

  void disposeState() {
    toDispose = true;
    _event.emit("dispose", null, "");
  }

  ///decides if [HistoryField] can be disposed
  bool toDispose = false;

  @override
  _HistoryFieldState createState() => _HistoryFieldState();
}

class _HistoryFieldState extends State<HistoryField>
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
          style: widget.old
              ? const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF696969),
                )
              : const TextStyle(
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
