import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  const Ball({this.diameter = 20, Key? key}) : super(key: key);

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration:
          BoxDecoration(color: Colors.amber[400], shape: BoxShape.circle),
    );
  }
}
