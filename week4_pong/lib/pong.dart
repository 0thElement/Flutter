import 'package:flutter/material.dart';
import 'ball.dart';
import 'bat.dart';

class PongGame extends StatefulWidget {
  const PongGame({Key? key}) : super(key: key);

  @override
  State<PongGame> createState() => _PongGameState();
}

class _PongGameState extends State<PongGame>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  double height = 0;
  double width = 0;

  int vDir = 3;
  int hDir = 3;

  double ballX = 0;
  double ballY = 0;
  double barX = 0;

  @override
  void initState() {
    ballX = 0;
    ballY = 0;
    barX = 0;
    controller =
        AnimationController(duration: const Duration(hours: 9999), vsync: this);
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      setState(() {
        ballX += hDir;
        ballY += vDir;
      });
      if ((ballX >= width - height / 20 && hDir > 0) ||
          (ballX <= 0 && hDir < 0)) hDir *= -1;
      if ((ballY >= height - height / 20 && vDir > 0) ||
          (ballY <= 0 && vDir < 0)) vDir *= -1;
    });
    controller.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;

        return Stack(
          children: [
            Positioned(
                child: Ball(
                  diameter: height / 20,
                ),
                top: ballY,
                left: ballX),
            Positioned(
              child: Bat(
                width: width / 5,
                height: height / 50,
              ),
              bottom: 0,
            )
          ],
        );
      },
    );
  }
}
