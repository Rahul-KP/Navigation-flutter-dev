import 'dart:convert';
import 'package:AmbiNav/shared_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';

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
  TextEditingController patient_name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController preferred_hosp = TextEditingController();
  String? gender;
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
                      SharedData.ref =
                          FirebaseDatabase.instance.ref("Bookings");
                      LocationData ld = await SharedData.locationData.first;
                      //call to hashing function
                      String hashvalue = AmbulanceForm().generateFormHash(
                          patient_name.text, age.text, preferred_hosp.text);
                      SharedData.ref.update({
                        hashvalue: {
                          "patient_name": patient_name.text,
                          "age": age.text,
                          "preferred_hospital": preferred_hosp.text,
                          "gender": gender,
                          "user_location": {
                            "lat": ld.latitude,
                            "lon": ld.longitude,
                          }
                        }
                      });
                      // ref.set({
                      //   "patient_name": patient_name.text,
                      //   "age": age.text,
                      //   "preferred_hospital": preferred_hosp.text
                      // });
                    },
                  ))
                ],
              ),
            )));
  }
}
