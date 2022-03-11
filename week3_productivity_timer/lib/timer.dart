import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async';

class TimerModel {
  late String time;
  late double percentage;

  String formatText(Duration t) {
    String minutes = t.inMinutes.toString().padLeft(2, '0');
    String seconds = (t.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  static TimerModel zero() {
    return TimerModel(Duration.zero, Duration.zero);
  }

  TimerModel(Duration time, Duration full) {
    this.time = formatText(time);
    if (full.inSeconds == 0) {
      percentage = 0;
    } else {
      percentage = time.inSeconds / full.inSeconds;
    }
  }
}

class CountdownTimer {
  late bool _isActive = false;
  Duration _time = Duration.zero;
  Duration _fulltime = Duration.zero;
  VoidCallback? onFinish;

  CountdownTimer() {
    setTimer(Duration.zero);
  }

  void setTimer(Duration duration) {
    _time = duration;
    _fulltime = duration;
  }

  void pauseTimer() {
    _isActive = false;
  }

  void startTimer(VoidCallback onFinish) {
    this.onFinish = onFinish;
    if (_time.inSeconds <= 0) return;
    _isActive = true;
  }

  TimerModel get timerModel => TimerModel(_time, _fulltime);
  bool get isActive => _isActive;

  final Duration oneSecond = const Duration(seconds: 1);

  Stream<TimerModel> createStream() async* {
    yield timerModel;
    yield* Stream.periodic(oneSecond, (computationCount) {
      if (_isActive) _time -= oneSecond;
      if (_time.inSeconds == 0) {
        pauseTimer();
        onFinish?.call();
      }
      return timerModel;
    });
  }
}

class TimerProgress extends StatelessWidget {
  final double radius;
  final TimerModel timerModel;
  const TimerProgress(this.radius, this.timerModel, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CircularPercentIndicator(
        radius: radius,
        lineWidth: 10.0,
        percent: timerModel.percentage,
        center:
            Text(timerModel.time, style: Theme.of(context).textTheme.headline4),
        progressColor: const Color(0xff009688),
      ),
    );
  }
}
