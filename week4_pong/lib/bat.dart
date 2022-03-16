import 'package:flutter/material.dart';

class Bat extends StatelessWidget {
  const Bat({this.width = 100, this.height = 20, Key? key}) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.blue[900]),
    );
  }
}
