import 'package:flutter/material.dart';
import 'package:navigation/AmbDriverDetails.dart';
import 'package:navigation/userDetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bordered_text/bordered_text.dart';

class loginpg extends StatelessWidget {
  const loginpg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
          centerTitle: true,
          title: Text("Choose Your Role",
          style: GoogleFonts.bebasNeue(
            fontSize: 30,
          )
          ),
          backgroundColor: Colors.green,
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: Text(
                    "Ambulance Driver",
                    style: GoogleFonts.bebasNeue(),
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text("User"),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("Reset roles"),
                )
              ],
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 95.0,
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                child: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 52, 164, 56),
                  backgroundImage: AssetImage('images/ambi2.png'),
                  radius: 90.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              BorderedText(
                strokeWidth: 5,
                strokeColor: Colors.white,
                child: Text("AmbiNav",
                style: GoogleFonts.bebasNeue(
                  fontSize: 40,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.5,
                 )
                ), ),

              SizedBox(
                height: 20.0,
              ),
              Text(
                "Choose your Role",
                style: TextStyle(
                    color: Colors.green,

                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                    // fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
              SizedBox(
                height: 40.0,
                width: 260.0,
                child: Divider(
                  color: Color.fromARGB(255, 243, 249, 251),
                  thickness: 1.6,
                ),
              ),
              Card(
                borderOnForeground: true,
                color: Colors.grey[200],
                elevation: 8.0,
                shadowColor: Colors.black,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    debugPrint('Card tapped.');
                    // Connect to map
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AmbiDriverDetails()));
                  },
                  child: const SizedBox(
                    width: 200,
                    height: 50,
                    child: Center(child: Text('Ambulance Driver')),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Card(
                color: Colors.grey[200],
                elevation: 8.0,
                shadowColor: Color.fromARGB(255, 60, 63, 61),
                child: InkWell(
                  splashColor: Color.fromARGB(255, 19, 148, 36).withAlpha(30),
                  onTap: () {
                    debugPrint('Card tapped.');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => userDetails()));
                    // Connect to map
                  },
                  child: const SizedBox(
                    width: 200,
                    height: 50,
                    child: Center(child: Text('User Driver')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
