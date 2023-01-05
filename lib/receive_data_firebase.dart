import 'package:AmbiNav/send_data_firebase.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirstRoute extends StatefulWidget {
  const FirstRoute({super.key});

  @override
  State<FirstRoute> createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
  final dr = FirebaseDatabase.instance.ref("AmbLoc");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Page"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
                query: dr,
                itemBuilder: (context, snapshot, animation, index) {
                  return ListTile(
                    title: Text(snapshot.child('long').value.toString()),
                    subtitle: Text(snapshot.child('lat').value.toString()),
                  );
                }),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => firebaseReceive()));
            },
            child: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
