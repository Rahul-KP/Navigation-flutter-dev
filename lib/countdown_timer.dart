import 'dart:math';

import 'package:AmbiNav/navig_notif_overlay_ui.dart';
import 'package:AmbiNav/shared_data.dart';
import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  late AnimationController controller;

  String get seconds {
    Duration duration = controller.duration!;
    return (duration.inSeconds % 60).toString();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    controller.forward(from: controller.value);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        SharedData.setStateOverlay(() {
          NavigationNotif.toggleVisibility();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(30),
        height: 70,
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return CustomPaint(
                      size: Size(40, 40),
                      painter: CustomTimerPainter(
                          animation: controller,
                          color: Colors.white,
                          backgroundColor: Colors.blue));
                },
              ),
              VerticalDivider(
                width: 20,
              ),
              Text(seconds)
            ],
          ),
        ));
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter(
      {required this.animation,
      required this.color,
      required this.backgroundColor})
      : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
