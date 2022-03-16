import 'package:flutter/material.dart';
import 'widgets/settings_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static final Settings _instance = Settings();
  static initialize() async {
    _instance.prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences? prefs;

  static int get workTime {
    int? value = _instance.prefs?.getInt("work");
    if (value == null) return 60;
    return value;
  }

  static set workTime(int? value) {
    value ??= 0;
    if (value <= 0) return;
    _instance.prefs?.setInt("work", value);
  }

  static int get shortBreak {
    int? value = _instance.prefs?.getInt("short");
    if (value == null) return 15;
    return value;
  }

  static set shortBreak(int? value) {
    value ??= 0;
    if (value <= 0) return;
    _instance.prefs?.setInt("short", value);
  }

  static int get longBreak {
    int? value = _instance.prefs?.getInt("long");
    if (value == null) return 30;
    return value;
  }

  static set longBreak(int? value) {
    value ??= 0;
    if (value <= 0) return;
    _instance.prefs?.setInt("long", value);
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const SettingsWidget(),
    );
  }
}

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
  final TextStyle textStyle = const TextStyle(fontSize: 24);

  late TextEditingController workTextEdit;
  late TextEditingController shortTextEdit;
  late TextEditingController longTextEdit;

  void setWorkTime(int value) {
    Settings.workTime = value;
    updateText();
  }

  void setShortBreak(int value) {
    Settings.shortBreak = value;
    updateText();
  }

  void setLongBreak(int value) {
    Settings.longBreak = value;
    updateText();
  }

  @override
  void initState() {
    workTextEdit = TextEditingController();
    shortTextEdit = TextEditingController();
    longTextEdit = TextEditingController();
    initSettings();
    super.initState();
  }

  void initSettings() async {
    await Settings.initialize();
    updateText();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 3,
      childAspectRatio: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        Text("Work", style: textStyle),
        const Text(""),
        const Text(""),
        SettingsButton(const Color(0xff455a64), "-", () {
          setWorkTime(Settings.workTime - 1);
        }),
        TextField(
          style: textStyle,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          controller: workTextEdit,
        ),
        SettingsButton(const Color(0xff009688), "+", () {
          setWorkTime(Settings.workTime + 1);
        }),
        Text("Short", style: textStyle),
        const Text(""),
        const Text(""),
        SettingsButton(const Color(0xff455a64), "-", () {
          setShortBreak(Settings.shortBreak - 1);
        }),
        TextField(
          style: textStyle,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          controller: shortTextEdit,
        ),
        SettingsButton(const Color(0xff009688), "+", () {
          setShortBreak(Settings.shortBreak + 1);
        }),
        Text("Long", style: textStyle),
        const Text(""),
        const Text(""),
        SettingsButton(const Color(0xff455a64), "-", () {
          setLongBreak(Settings.longBreak - 1);
        }),
        TextField(
          style: textStyle,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          controller: longTextEdit,
        ),
        SettingsButton(const Color(0xff009688), "+", () {
          setLongBreak(Settings.longBreak + 1);
        }),
      ],
      padding: const EdgeInsets.all(20),
    );
  }

  void updateText() {
    setState(() {
      workTextEdit.text = Settings.workTime.toString();
      shortTextEdit.text = Settings.shortBreak.toString();
      longTextEdit.text = Settings.longBreak.toString();
    });
  }
}
