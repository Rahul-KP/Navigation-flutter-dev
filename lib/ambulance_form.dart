import 'dart:convert';
import 'package:AmbiNav/app_screen_ui.dart';
import 'package:AmbiNav/grid.dart';
import 'package:AmbiNav/main.dart';
import 'package:AmbiNav/map_functions.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';

// User defined ambulance form widget
class AmbulanceForm extends StatefulWidget {
  Services sobj;
  AmbulanceForm({super.key, required this.sobj});
  @override
  AmbulanceFormState createState() {
    return AmbulanceFormState();
  }
}

// The form state class
class AmbulanceFormState extends State<AmbulanceForm> {
  // a global key to validate form and identify widget
  final _formKey = GlobalKey<FormState>();
  final appTitle = 'Book an Ambulance';
  // final AppScreen aobj = AppScreen();
  TextEditingController patient_name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController preferred_hosp = TextEditingController();
  String? gender;

  String generateFormHash(String name, String age, String hospital) {
    var bytes = utf8.encode(name + age + hospital);
    var hash = sha256.convert(bytes);
    return hash.toString();
  }

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
                      _book();
                      //listen to firebase to plot path on user side
                      // ref.set({
                      //   "patient_name": patient_name.text,
                      //   "age": age.text,
                      //   "preferred_hospital": preferred_hosp.text
                      // });
                      widget.sobj.goToUserLoc();
                      MapServices.mapController.camera.zoomTo(20);
                      while (MapServices.mapController.camera.boundingBox ==
                          null) {}
                      print("Grid is to be drawn after submit!");
                      Grid grid = Grid();
                      grid.isBooking = true;
                      Fluttertoast.showToast(msg: "Something");
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: ((context) => AppScreen(
                                sobj: sobj,
                                grid: grid,
                              ))));
                      Fluttertoast.showToast(msg: "hahahah");
                      // grid.getGrid(true);
                    },
                  ))
                ],
              ),
            )));
  }

  void _book() async {
    var box = await Hive.openBox('booking');
    // GeoCoordinates userLoc = await MapServices().getCurrentLoc();

    String hashvalue =
        generateFormHash(patient_name.text, age.text, preferred_hosp.text);

    box.put('name', patient_name.text);
    box.put('age', age.text);
    box.put('preferred_hosp', preferred_hosp.text);
    box.put('gender', gender!);
    box.put('lat', sobj.userLocation!.latitude);
    box.put('lon', sobj.userLocation!.longitude);
    box.put('hash', hashvalue);
  }
}
