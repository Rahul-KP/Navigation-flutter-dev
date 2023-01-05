import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class firebaseReceive extends StatefulWidget {
  const firebaseReceive({super.key});

  @override
  State<firebaseReceive> createState() => _firebaseReceiveState();
}

class _firebaseReceiveState extends State<firebaseReceive> {
  get floatingActionButton => null;

  final dr = FirebaseDatabase.instance.ref("AmbLoc");
  final locController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: locController,
            decoration: InputDecoration(
              hintText: ("lat and long"),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              dr
                  .child(DateTime.now().second.toString())
                  .set({'lat': locController.text.toString(), 'long': locController.text.toString()}).then((value) => {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Added location"),
                        ))
                      });
            },
            child: const Text('Add'),
          ),
        ]),
      ),
    );
  }
}
