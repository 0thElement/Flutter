import 'package:flutter/material.dart';
import 'pong.dart';

void main() {
  runApp(const PongApplication());
}

class PongApplication extends StatelessWidget {
  const PongApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pong Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PongHomepage(title: 'Simple Pong'),
    );
  }
}

class PongHomepage extends StatelessWidget {
  const PongHomepage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const SafeArea(child: PongGame()),
    );
  }
}
