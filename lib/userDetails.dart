import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navigation/starter.dart';

class userDetails extends StatefulWidget {
  const userDetails({super.key});

  @override
  State<userDetails> createState() => _userDetailsState();
}

class _userDetailsState extends State<userDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 90,
              ),
              Text(
                'User Driver',
                style: GoogleFonts.bebasNeue(
                  fontSize: 40,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Enter your details',
                style: TextStyle(
                  fontSize: 20,
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
                    hintText: 'Name',
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
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.green.shade600),
                    ),
                    hintText: 'Phone number',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  // onTap: Map(),
                  child: Container(
                    width: 160,
                    child: InkWell(
                      splashColor: Color.fromARGB(255, 5, 181, 5).withAlpha(30),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => loginpg()));
                        ;
                      },
                      child: Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: Color.fromARGB(255, 14, 133, 12)),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                fontSize: 18,
                              ),
                            ),
                          )),
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
                  Text(
                    '  Click here',
                    style: TextStyle(
                        color: Colors.blue[600],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}





                    // need inkwell inside conatiner
                    // padding: EdgeInsets.all(20),
                    // decoration: BoxDecoration(
                    //     color:Colors.green[400],
                    //     borderRadius: BorderRadius.circular(15)),
                    // child: Center(
                    //   child: Text(
                    //     'Next',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.bold,
                    //       letterSpacing: 1,
                    //       fontSize: 16,
                    //     ),
                    //   ),
                    // )