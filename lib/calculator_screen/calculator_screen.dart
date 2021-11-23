import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'history_field.dart';

///Used to display actions from [ButtonPanel]
class CalculatorScreen extends StatelessWidget {
  CalculatorScreen({Key? key, required this.height}) : super(key: key);

  ///list of all past and present equations
  final _history = [HistoryField('0')];
  final _historyKey = GlobalKey<AnimatedListState>();
  final _controller = ScrollController();
  final double height;

  ///Sets currently edited equation as [newValue]
  void setDisplay(String newValue) {
    //scroll to bottom
    _controller.jumpTo(_controller.position.minScrollExtent);

    _history[0].set(newValue);
  }

  ///Writes [newValue] in a new line saving previous result in [_history]
  void newLine(String newValue) {
    //scroll to bottom
    _controller.jumpTo(_controller.position.minScrollExtent);

    _history[0].add("=");
    //result in history
    _history.insert(0, HistoryField(newValue + "\n"));
    _historyKey.currentState!.insertItem(
      0,
      duration: const Duration(seconds: 0),
    );
    //result as current value
    _history.insert(0, HistoryField(newValue));
    _historyKey.currentState!.insertItem(
      0,
      duration: const Duration(milliseconds: 100),
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

          //mark older calculations
          if (index > 0) _history[index].old = true;
          //make disposable all _history lines except 3 most recent
          if (index >= 3) {
            _history[index].disposeState();
          }

          return _history[index];
        },
        reverse: true,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0),
        controller: _controller,
      ),
      height: height,
    );
  }
}
