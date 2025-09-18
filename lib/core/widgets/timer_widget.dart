import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerWidget extends StatefulWidget {
  final TextStyle? textStyle;
final Function()? onReset;
  const TimerWidget(
      {super.key,
        this.textStyle, this.onReset,});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  final StopWatchTimer _stopWatchTimer =
  StopWatchTimer(mode: StopWatchMode.countDown, presetMillisecond: 60000);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stopWatchTimer.onStartTimer();
    _stopWatchTimer.secondTime.listen((event) {
      if (event == 0) {
       widget.onReset?.call();
       _stopWatchTimer.onResetTimer();
       _stopWatchTimer.onStartTimer();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _stopWatchTimer.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _stopWatchTimer.secondTime,
      initialData: 60,
      builder: (context, snap) {
        final value = snap.data ?? 0;

        return  Text(
          StopWatchTimer.getDisplayTime(
        StopWatchTimer.getMilliSecFromSecond(value),
        hours: false,
        minute: true,
        second: true,
        milliSecond: false),
          style: widget.textStyle,
        );
      },
    );
  }
}
