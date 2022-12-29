import 'package:AmbiNav/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'search_overlay_ui.dart';
import 'app_screen_res.dart';
import 'map.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  void initState() {
    super.initState();
    MapScreenRes.getPermissions();

    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(notification != null && android!= null){
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              color: Colors.amber,
              playSound: true,

            )
          )
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(' A new onMessageOpendApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(notification != null && android !=null){
        showDialog(context: context,
         builder: (_){
          return AlertDialog(
            title: Text(notification.title.toString()),
            content: SingleChildScrollView(
              child:  Column(
                children: [
                  Text(notification.body.toString())
                ]),
            ),
          );
         });
      }
     });
  }

  void showNotification(){
    flutterLocalNotificationsPlugin.show(
      0,
      "Testing ",
      "Hoe are you",
      NotificationDetails(
        android: AndroidNotificationDetails(
               channel.id,
        channel.name,
        color: Colors.amber,
        importance: Importance.high,
        playSound: true,
        )
   

      )
    );
  }

  //used to reference setState() for search widget (setState is copied to this variable in StatefulBuilder)
  var setStateOverlay;

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(),
      appBar: AppBar(
          title: Text("Navigation"),
          leading: IconButton(
            //hamburger icon
            icon: Icon(Icons.menu),
            onPressed: () {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.closeDrawer();
              } else {
                scaffoldKey.currentState!.openDrawer();
              }
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: (() =>
                    setStateOverlay(() => SearchWidget.toggleVisisbility())),
              ),
            ),
          ]),
      body: Stack(
        children: <Widget>[
          // MapWidget
          MapWidget(),
          //here the stateful builder is used to render search widget of search.dart (a card element to enter destination)
          //it renders without redrawing the entire screen
          //if the below lines are not included , map will be redrawn every time the search button is toggled
          StatefulBuilder(builder: ((context, setState) {
            setStateOverlay = setState;
            return SearchWidget();
          })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          //this button moves the camera to user's current location - recenter button
          onPressed: (){
            (MapScreenRes.goToUserLoc);
            showNotification();
          },
          child: const Icon(
            Icons.add_location_alt_outlined,
            color: Colors.white,
          )),

          // RaisedButton(
          //      color: Colors.blueAccent, 
          //      onPressed: () {
          //      sendData(); //fun1
          //      signupPage(context); //fun2
          //      },
          //      child: 
          //       Text("Signup"),
          //    )

      // floatingActionButton : FloatingActionButton(
      //   onPressed: showNotification,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),

      

    );
  }
}
