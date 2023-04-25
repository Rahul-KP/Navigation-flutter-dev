import 'package:AmbiNav/app_screen_ui.dart';
import 'package:AmbiNav/main.dart';
import 'package:AmbiNav/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'starter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'main.dart' as mm;

class AmbiDriverDetails extends StatefulWidget {
  AmbiDriverDetails({super.key, required Services sobj});
  @override
  State<AmbiDriverDetails> createState() => _AmbiDriverDetailsState();
}

class _AmbiDriverDetailsState extends State<AmbiDriverDetails> {
  // final myController = TextEditingController();

  final nameController = TextEditingController();
  final codeController = TextEditingController();

  late SharedPreferences logindata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.airport_shuttle_outlined,
                  size: 90,
                ),
                Text(
                  'Ambulance Driver',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 40,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Enter your details ',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.green.shade600),
                      ),
                      hintText: 'Ambulance Driver Name',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.green.shade600),
                      ),
                      hintText: 'Ambulance Code',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: () async {
                      logindata = await SharedPreferences.getInstance();
                      String username = nameController.text;
                      String code = codeController.text;

                      if (username != '' && code != '') {
                        logindata.setBool('login', false);

                        logindata.setString('username', username);
                        logindata.setString('usertype', 'driver');
                        // Services.usertype = 'driver';  
                        sobj.usertype='driver';                   
                        sobj.username=username;
                        Fluttertoast.showToast(msg: username);
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppScreen(sobj: sobj)));
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.green[400],
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          'Move to Map    🗺️',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Want to change role ?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: ((context) => loginpg(sobj: sobj,))));
                        },
                        child: Text(
                          '  Click here',
                          style: TextStyle(
                              color: Colors.blue[600],
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    super.dispose();
  }
}
