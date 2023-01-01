import 'package:AmbiNav/countdown_timer.dart';
import 'package:flutter/material.dart';

class NavigationNotif extends StatefulWidget {
  const NavigationNotif({super.key});
  static bool isVisible = false;

  @override
  State<NavigationNotif> createState() => _NavigationNotifState();

  static void toggleVisibility() {
    isVisible = !isVisible;
  }
}

class _NavigationNotifState extends State<NavigationNotif> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: CountDownTimer(),
      visible: NavigationNotif.isVisible,
    );
  }
}
