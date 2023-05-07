import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';

class EndDes extends StatefulWidget {
  static  bool isVisible = false;
  Services sbj;
  static late Routing rt ; 
  EndDes({super.key, required this.sbj});

  @override
  State<EndDes> createState() => _EndDesState();
}

class _EndDesState extends State<EndDes> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: ElevatedButton(
        onPressed: () {
          EndDes.rt.removeRoute();
        },

        // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
        style: ElevatedButton.styleFrom(
            elevation: 12.0,
            textStyle: const TextStyle(color: Colors.white),
            backgroundColor: Colors.blue[400]),
        child: const Text('End Destination'),
      ),
      visible: EndDes.isVisible,
    );
  }
}
