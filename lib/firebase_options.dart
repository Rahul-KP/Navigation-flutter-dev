// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDYbewlAjcEZeXbw-z7XaIlZScb2utkgy4',
    appId: '1:361650748719:web:27f5d39c5ba6eba7ee35da',
    messagingSenderId: '361650748719',
    projectId: 'ambinav-bbc44',
    authDomain: 'ambinav-bbc44.firebaseapp.com',
    databaseURL: 'https://ambinav-bbc44-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ambinav-bbc44.appspot.com',
    measurementId: 'G-7Y8B2NS6Y3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUugs5-WL1hkGrC0ZenS2SrmL5mcCUZKo',
    appId: '1:361650748719:android:c6213549b2402efbee35da',
    messagingSenderId: '361650748719',
    projectId: 'ambinav-bbc44',
    databaseURL: 'https://ambinav-bbc44-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ambinav-bbc44.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCnyHLTu2NGwaeQJO-gBbEJaOVe5Yr9YxY',
    appId: '1:361650748719:ios:2d70b938cd2ef900ee35da',
    messagingSenderId: '361650748719',
    projectId: 'ambinav-bbc44',
    databaseURL: 'https://ambinav-bbc44-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ambinav-bbc44.appspot.com',
    iosClientId: '361650748719-0ejsbo8b8n5s01euhfj8eo71j4rter5g.apps.googleusercontent.com',
    iosBundleId: 'com.example.navigation',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCnyHLTu2NGwaeQJO-gBbEJaOVe5Yr9YxY',
    appId: '1:361650748719:ios:2d70b938cd2ef900ee35da',
    messagingSenderId: '361650748719',
    projectId: 'ambinav-bbc44',
    databaseURL: 'https://ambinav-bbc44-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ambinav-bbc44.appspot.com',
    iosClientId: '361650748719-0ejsbo8b8n5s01euhfj8eo71j4rter5g.apps.googleusercontent.com',
    iosBundleId: 'com.example.navigation',
  );
}
