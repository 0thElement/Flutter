import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton(this.color, this.text, this.callback, {Key? key})
      : super(key: key);

  final Color color;
  final String text;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: () => callback(), color: color, child: Text(text));
  }
}
