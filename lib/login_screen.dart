import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Widget Btn(String text_) {
    return Container(
        width: 200,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.amber,
            border: Border.all(color: Colors.amber),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Text(
            text_,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Navigation'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Vertical alignment
            children: [Btn('AMBULANCE DRIVER'), Btn('USER')],
          ),
        ));
  }
}
