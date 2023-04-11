import 'dart:convert';
import 'package:AmbiNav/app_screen_ui.dart';
import 'package:AmbiNav/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:AmbiNav/grid2.dart' as glay;

// User defined ambulance form widget
class AmbulanceForm extends StatefulWidget {
  @override
  AmbulanceFormState createState() {
    return AmbulanceFormState();
  }

  String generateFormHash(String name, String age, String hospital) {
    var bytes = utf8.encode(name + age + hospital);
    var hash = sha256.convert(bytes);
    return hash.toString();
  }
}

// The form state class
class AmbulanceFormState extends State<AmbulanceForm> {
  // a global key to validate form and identify widget
  final _formKey = GlobalKey<FormState>();
  final appTitle = 'Book an Ambulance';
  final AppScreen aobj = AppScreen();
  TextEditingController patient_name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController preferred_hosp = TextEditingController();
  String? gender;

  glay.Grid grid1 = glay.Grid();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appTitle,
        home: Scaffold(
            appBar: AppBar(
              title: Text(appTitle),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: patient_name,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter patient name',
                      labelText: 'Patient Name',
                    ),
                  ),
                  TextField(
                    controller: age,
                    decoration: new InputDecoration(
                        icon: const Icon(Icons.numbers_rounded),
                        labelText: 'Patient age',
                        hintText: 'Enter patient age'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  DropdownButton<String>(
                    hint: Text("Select Gender"),
                    value: gender,
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        gender = value!;
                      });
                    },
                    items: ["Male", "Female", "Other"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  TextField(
                    controller: preferred_hosp,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.local_hospital),
                      hintText: 'Enter preferred hospital',
                      labelText: 'Preferred hospital',
                    ),
                  ),
                  new Container(
                      // padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                      child: new ElevatedButton(
                    child: const Text("Submit"),
                    onPressed: () async {
                      Services.ref = FirebaseDatabase.instance.ref("Bookings");
                      //call to hashing function
                      String hashvalue = AmbulanceForm().generateFormHash(
                          patient_name.text, age.text, preferred_hosp.text);
                      Services.ref.update({
                        hashvalue: {
                          "patient_name": patient_name.text,
                          "age": age.text,
                          "preferred_hospital": preferred_hosp.text,
                          "gender": gender,
                          "user_location": {
                            "lat": Services.userLocation.latitude,
                            "lon": Services.userLocation.longitude,
                          }
                        }
                      });
                      AppScreen.scaffoldKey.currentState!.closeDrawer();

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: ((context) => AppScreen())));
                      // ref.set({
                      //   "patient_name": patient_name.text,
                      //   "age": age.text,
                      //   "preferred_hospital": preferred_hosp.text
                      // });
                      print("Grid is to be drawn after submit!");
                      grid1.init();
                      grid1.getGrid();
                    },
                  ))
                ],
              ),
            )));
  }
}
