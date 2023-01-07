import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(BookAmbulance());

class BookAmbulance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Book an Ambulance';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: AmbulanceForm(),
      ),
    );
  }
}

// User defined ambulance form widget
class AmbulanceForm extends StatefulWidget {
  @override
  AmbulanceFormState createState() {
    return AmbulanceFormState();
  }
}

// The form state class
class AmbulanceFormState extends State<AmbulanceForm> {
  // a global key to validate form and identify widget
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'Enter patient name',
              labelText: 'Patient Name',
            ),
          ),
          TextField(
            decoration: new InputDecoration(
                icon: const Icon(Icons.numbers_rounded),
                labelText: 'Enter patient age'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          ),
          DropdownButton<String>(
            items: ['Male','Female','Other'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
          TextField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.local_hospital),
              hintText: 'Enter preferred hospital',
              labelText: 'Preferred hospital',
            ),
          ),
          new Container(
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),
              child: new ElevatedButton(
                child: const Text("Submit"),
                onPressed: null,
              ))
        ],
      ),
    );
  }
}
