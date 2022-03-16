import 'dart:math';

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

  double height = 999;
  double width = 999;

  double vDir = 3;
  double hDir = -3;

  double ballX = 0;
  double ballY = 0;
  double batX = 0;

  double get ballDiameter => height / 20;
  double get batWidth => width / 5;
  double get batHeight => height / 50;

  bool started = false;

  int score = 0;

  final Random random = Random();

  @override
  void initState() {
    ballX = 0;
    ballY = 0;
    batX = 0;
    score = 0;

    controller =
        AnimationController(duration: const Duration(hours: 9999), vsync: this);
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        ballX += hDir;
        ballY += vDir;
        if ((ballX >= width - ballDiameter && hDir > 0) ||
            (ballX <= 0 && hDir < 0)) {
          hDir *= -1;
        }
        if (ballY <= 0 && vDir < 0) {
          vDir *= -1;
        }
        if (ballY >= height - ballDiameter - batHeight && vDir > 0) {
          if (ballX >= (batX - ballDiameter) &&
              ballX <= (batX + ballDiameter + batWidth)) {
            vDir *= -1;
            score++;
            vDir *= 1.1;
            hDir *= 1.1;
          } else if (ballY >= height - ballDiameter) {
            controller.stop();
            showGameOverMessage(context);
          }
        }
      });
    });

    controller.forward();
    super.initState();
  }

  void moveBat(DragUpdateDetails drag) {
    safeSetState(() {
      started = true;
      batX += drag.delta.dx;
      batX = (batX > width - batWidth) ? width - batWidth : batX;
      batX = (batX < 0) ? 0 : batX;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: (DragUpdateDetails drag) => moveBat(drag),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            height = constraints.maxHeight;
            width = constraints.maxWidth;
            if (!started) {
              batX = (width - batWidth) / 2;
              ballX = random.nextDouble() * (width - ballDiameter);
              ballY = random.nextDouble() * (height / 2 - ballDiameter);
            }
            started = true;

            return Stack(
              children: [
                Positioned(
                    child: Ball(
                      diameter: ballDiameter,
                    ),
                    top: ballY,
                    left: ballX),
                Positioned(
                  bottom: 0,
                  left: batX,
                  child: Bat(
                    width: batWidth,
                    height: batHeight,
                  ),
                ),
                Positioned(
                    child: Text(
                      'Score: $score',
                      textAlign: TextAlign.right,
                    ),
                    top: 10,
                    right: 10)
              ],
            );
          },
        ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  void showGameOverMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Game over"),
            content: const Text("Try again?"),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    ballX = 0;
                    ballY = 0;
                    score = 0;
                    vDir = 3;
                    vDir = -3;
                    started = false;
                  });
                  Navigator.of(context).pop();
                  controller.repeat();
                },
                child: const Text('Yes'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    dispose();
                  },
                  child: const Text('No')),
            ],
          );
        });
  }
}
