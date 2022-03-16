import 'package:flutter/material.dart';

import 'widgets/productivity_button.dart';
import 'timer.dart';
import 'settings.dart';

double defaultPadding = 3;

void main() {
  runApp(const TimerApplication());
}

class TimerApplication extends StatelessWidget {
  const TimerApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productivity Timer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatefulWidget {
  const TimerHomePage({Key? key}) : super(key: key);

  @override
  State<TimerHomePage> createState() => _TimerHomePageState();
}

class _TimerHomePageState extends State<TimerHomePage> {
  Stream<TimerModel>? _stream;
  final CountdownTimer timer = CountdownTimer();

  bool get timerActive => timer.isActive;
  void setTimer(Duration t) {
    setState(() {
      timer.setTimer(t);
      _stream = timer.createStream();
    });
  }

  void startTimer() {
    setState(() {
      timer.startTimer(pauseTimer);
    });
  }

  void pauseTimer() {
    setState(() {
      timer.pauseTimer();
    });
  }

  @override
  void initState() {
    Settings.initialize();
    super.initState();
  }

  final List<PopupMenuItem<String>> menuItems = [
    const PopupMenuItem(value: 'Settings', child: Text('Settings'))
  ];

  void toSettingsMenu(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productivity Timer'),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return menuItems.toList();
            },
            onSelected: (item) {
              if (item == 'Settings') {
                toSettingsMenu(context);
              }
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: ((context, constraints) {
          final double availableWidth = constraints.maxWidth;

          return Column(
            children: [
              Row(children: [
                ProductivityButton(
                  text: "Work",
                  color: const Color(0xff009688),
                  padding: defaultPadding,
                  disabled: timerActive,
                  callback: () =>
                      setTimer(Duration(minutes: Settings.workTime)),
                ),
                ProductivityButton(
                  text: "Short Break",
                  color: const Color(0xff607D8b),
                  padding: defaultPadding,
                  disabled: timerActive,
                  callback: () =>
                      setTimer(Duration(minutes: Settings.shortBreak)),
                ),
                ProductivityButton(
                  text: "Long Break",
                  color: const Color(0xff455a64),
                  padding: defaultPadding,
                  disabled: timerActive,
                  callback: () =>
                      setTimer(Duration(minutes: Settings.longBreak)),
                )
              ]),
              const Spacer(),
              Row(children: [
                StreamBuilder<TimerModel>(
                    stream: _stream,
                    builder: ((context, snapshot) {
                      TimerModel timerModel = (snapshot.data == null)
                          ? TimerModel.zero()
                          : snapshot.data!;

                      return TimerProgress(availableWidth / 2.5, timerModel);
                    }))
              ]),
              const Spacer(),
              Row(children: [
                timerActive
                    ? ProductivityButton(
                        text: "Pause",
                        color: const Color(0xff455a64),
                        padding: availableWidth / 10,
                        callback: pauseTimer,
                      )
                    : ProductivityButton(
                        text: "Start",
                        color: const Color(0xff009688),
                        padding: availableWidth / 10,
                        callback: startTimer,
                      ),
              ]),
              const Spacer(),
            ],
          );
        }),
      ),
    );
  }
}
