// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDPKLWVqQ9akc926UKReX_Le9c5aNN91F0',
    appId: '1:687178952062:android:7157c3f6746c15d9a4d72f',
    messagingSenderId: '687178952062',
    projectId: 'cgas-2024',
    storageBucket: 'cgas-2024.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJ_14whv6F0k9RCqbP1nECzxIihloVL1w',
    appId: '1:166603967395:ios:5665ade2d4079f520e2816',
    messagingSenderId: '166603967395',
    projectId: 'cgas-16f26',
    storageBucket: 'cgas-16f26.appspot.com',
    iosBundleId: 'com.example.cgasStudent',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDiPdMqr41xcHRuCzdPI25FD62YJM0gqVU',
    appId: '1:687178952062:web:50b9e15f35a51260a4d72f',
    messagingSenderId: '687178952062',
    projectId: 'cgas-2024',
    authDomain: 'cgas-2024.firebaseapp.com',
    storageBucket: 'cgas-2024.appspot.com',
    measurementId: 'G-18N69S219H',
  );

}