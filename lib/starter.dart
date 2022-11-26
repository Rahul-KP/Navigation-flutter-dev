import 'package:flutter/material.dart';
import 'package:navigation/AmbDriverDetails.dart';
import 'package:navigation/userDetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bordered_text/bordered_text.dart';

class loginpg extends StatelessWidget {
  const loginpg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/ambiBg.jpg"), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(221, 24, 24, 24),
              Color.fromARGB(221, 0, 0, 0)
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // appBar: PreferredSize(
          //   preferredSize: Size.fromHeight(90.0),
          //   child: AppBar(
          //     shape: const RoundedRectangleBorder(
          //         borderRadius: BorderRadius.only(
          //       bottomLeft: Radius.circular(20),
          //       bottomRight: Radius.circular(20),
          //     )),
          //     centerTitle: true,
          //     title: Text("Choose Your Role",
          //     style: GoogleFonts.bebasNeue(
          //       fontSize: 30,
          //     )
          //     ),
          //     backgroundColor: Colors.green,
          //     actions: [
          //       PopupMenuButton(
          //         itemBuilder: (context) => [
          //           PopupMenuItem(
          //             value: 0,
          //             child: Text(
          //               "Ambulance Driver",
          //               style: GoogleFonts.bebasNeue(),
          //             ),
          //           ),
          //           PopupMenuItem(
          //             value: 1,
          //             child: Text("User"),
          //           ),
          //           PopupMenuItem(
          //             value: 2,
          //             child: Text("Reset roles"),
          //           )
          //         ],
          //       )
          //     ],
          //   ),
          // ),
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 92.0,
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    child: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 5, 5, 5),
                      backgroundImage: AssetImage('images/ambi2.png'),
                      radius: 90.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  BorderedText(
                    strokeWidth: 4,
                    strokeColor: Color.fromARGB(255, 251, 251, 251),
                    child: Text("AMBINAV",
                        style: GoogleFonts.montserrat(
                          
                          fontSize: 40,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.5,
                        
                        )),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  
                  BorderedText(
                    strokeWidth: 0.8,
                    strokeColor: Color.fromARGB(255, 0, 0, 0),
                    child: Text("Choose your role",
                        style: GoogleFonts.rokkitt(
                           fontSize: 21,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        )),
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
                    shadowColor: Color.fromARGB(255, 255, 255, 255),
                    child: InkWell(
                      splashColor: Color.fromARGB(255, 25, 143, 96).withAlpha(30),
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
                        child: Center(
                          child: Text('Ambulance Driver',
                          style: TextStyle(
                            letterSpacing: 0.7,
                            fontSize: 16,
                          ),
                          ),
                          ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Card(
                    color: Colors.grey[200],
                    elevation: 8.0,
                    shadowColor: Color.fromARGB(255, 247, 248, 247),
                    child: InkWell(
                      splashColor:
                          Color.fromARGB(255, 72, 202, 21).withAlpha(30),
                      onTap: () {
                        debugPrint('Card tapped.');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => userDetails()));
                        // Connect to map
                      },
                      child: const SizedBox(
                        width: 200,
                        height: 50,
                        child: Center(child: Text('User Driver',
                        style: TextStyle(
                            letterSpacing: 0.7,
                            fontSize: 16,
                          ))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
