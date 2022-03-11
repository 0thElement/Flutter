import 'package:flutter/material.dart';

class ProductivityButton extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final double padding;
  final bool disabled;
  final VoidCallback? callback;

  const ProductivityButton(
      {this.text = "",
      this.size = 300,
      this.color = const Color.fromARGB(255, 112, 112, 112),
      this.padding = 5,
      this.disabled = false,
      this.callback,
      Key? key})
      : super(key: key);

  void onPressed() {
    if (disabled) return;
    callback?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.all(padding),
            child: MaterialButton(
                onPressed: onPressed,
                child: Text(text, style: const TextStyle(color: Colors.white)),
                color: color.withOpacity(disabled ? 0.4 : 1),
                minWidth: size,
                enableFeedback: !disabled)));
  }
}
