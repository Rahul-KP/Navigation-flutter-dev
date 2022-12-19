import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navigation/get_location.dart';
import 'package:navigation/starter.dart';
import 'package:navigation/userDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AmbiDriverDetails extends StatefulWidget {
  AmbiDriverDetails({super.key});

  @override
  State<AmbiDriverDetails> createState() => _AmbiDriverDetailsState();
}

class _AmbiDriverDetailsState extends State<AmbiDriverDetails> {
  final myController = TextEditingController();

  final nameConroller = TextEditingController();
  final codeController = TextEditingController();

  late SharedPreferences logindata;
  late bool newuser;

  void initState() {
    super.initState();

    // Start listening to changes.

    // getValidationData().whenComplete(() async {
      // if (finalAmbulanceCode == "") {
      //   userDetails();
      // } else {
      //   Pos();
      // }


    alreadyLoggedin();
  }

  // Future getValidationData() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   var obtainedAmbulanceCode =
  //       sharedPreferences.getString("ambulanceCode").toString();
  //   setState(() {
  //     finalAmbulanceCode = obtainedAmbulanceCode;
  //   });
  //   print(finalAmbulanceCode);
  // }

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
                    controller: nameConroller,
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

                      String username = nameConroller.text;
                      String code = codeController.text;

                      print(username);

                      if (username != '' && code != '') {
                        print("sucessssssss");
                        logindata.setBool('login', false);

                        logindata.setString('username', username);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Pos()));
                      }

                      
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: ((context) => Pos())));

                      // final SharedPreferences sharedPreferences =
                      //     await SharedPreferences.getInstance();

                      // sharedPreferences.setString(
                      //     "ambulanceCode", myController.text);

                      // Navigator.of(context).pushReplacement(
                      //     MaterialPageRoute(builder: ((context) => Pos())));
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
                                  builder: ((context) => loginpg())));
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

  void alreadyLoggedin() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);

    print(newuser);
    
    if (newuser == false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => Pos()));
    }
  }

  @override
  void dispose(){
    nameConroller.dispose();
    codeController.dispose();
    super.dispose();
  }
}
