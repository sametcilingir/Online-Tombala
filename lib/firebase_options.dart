// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB7YmTL9ib9l71VzHYmG8W9PDwnlS3qmP4',
    appId: '1:902803951272:web:dc10f392fcaa4e7fe97c9d',
    messagingSenderId: '902803951272',
    projectId: 'i-like-bingo-game',
    authDomain: 'i-like-bingo-game.firebaseapp.com',
    storageBucket: 'i-like-bingo-game.appspot.com',
    measurementId: 'G-63R7JMZWJ6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhHXVdB2MaB0yBwtZKb631qVLKUhnUxFw',
    appId: '1:902803951272:android:555a0cb28ea4383ae97c9d',
    messagingSenderId: '902803951272',
    projectId: 'i-like-bingo-game',
    storageBucket: 'i-like-bingo-game.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0q3jG0uw615WFXlL6uTDU9EeM48BQbuw',
    appId: '1:902803951272:ios:71f65f9586166944e97c9d',
    messagingSenderId: '902803951272',
    projectId: 'i-like-bingo-game',
    storageBucket: 'i-like-bingo-game.appspot.com',
    androidClientId: '902803951272-2hdm7pic56i6ncujp9eovq86r63gbi21.apps.googleusercontent.com',
    iosClientId: '902803951272-mjir5ccsjeqogprdbtp87rvuq7en1lll.apps.googleusercontent.com',
    iosBundleId: 'com.stappenterprise.tombala',
  );
}
