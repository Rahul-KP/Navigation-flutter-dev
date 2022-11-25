import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class loginpg extends StatelessWidget {
  const loginpg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: AppBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )),
            centerTitle: true,
            title: Text("Choose Your Role"),
            backgroundColor: Color.fromARGB(255, 7, 185, 255),
            actions: [
              PopupMenuButton(
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 0,
                          child: Text("Ambulance Driver",
                          style: GoogleFonts.sacramento(),),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: Text("User"),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Text("Reset roles"),
                        )
                      ],)
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
                  backgroundColor: Color.fromARGB(255, 24, 183, 246),
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 4, 134, 185),
                    backgroundImage: AssetImage('images/ambi2.png'),
                    radius: 90.0,
                  ),
                ),
                
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "AmbiNav",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 57, 7),
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Choose your Role",
                  style: TextStyle(
                      color: Color.fromARGB(255, 196, 39, 8),
                      fontSize: 17.0,
                      // fontWeight: FontWeight.bold,
                      letterSpacing: 1.5),
                ),
                SizedBox(
                  height: 40.0,
                  width: 260.0,
                  child: Divider(
                    color: Color.fromARGB(255, 7, 185, 255),
                    thickness: 1.6,
                  ),
                ),
                 Card(
                  color: Colors.white,
                  elevation: 8.0,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      debugPrint('Card tapped.');
                      // Connect to map
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
                  color: Color.fromARGB(255, 255, 255, 255),
                  elevation: 8.0,
                  shadowColor: Color.fromARGB(255, 3, 45, 64),
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      debugPrint('Card tapped.');
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





