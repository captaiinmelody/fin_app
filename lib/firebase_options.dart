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
    apiKey: 'AIzaSyCs-_2tfTXQ_BFfY-AHGh_bE9iKI4aXcbU',
    appId: '1:887180827198:web:b8d4ab93515d36f9af8f6f',
    messagingSenderId: '887180827198',
    projectId: 'fin-app-v1-44109',
    authDomain: 'fin-app-v1-44109.firebaseapp.com',
    storageBucket: 'fin-app-v1-44109.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9978Rs3uvNc7FaP7jovoAYbAkWSnenWk',
    appId: '1:887180827198:android:4420aec1023f6d3aaf8f6f',
    messagingSenderId: '887180827198',
    projectId: 'fin-app-v1-44109',
    storageBucket: 'fin-app-v1-44109.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXTxO6SuOnY10uBCJxlXfaPT4D6i2O1cU',
    appId: '1:887180827198:ios:488a6f41e563fc05af8f6f',
    messagingSenderId: '887180827198',
    projectId: 'fin-app-v1-44109',
    storageBucket: 'fin-app-v1-44109.appspot.com',
    iosClientId:
        '887180827198-hmlf1nap8s1r76un627u2eqe2oj9tuao.apps.googleusercontent.com',
    iosBundleId: 'com.example.finApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBXTxO6SuOnY10uBCJxlXfaPT4D6i2O1cU',
    appId: '1:887180827198:ios:68f39eef95d3986baf8f6f',
    messagingSenderId: '887180827198',
    projectId: 'fin-app-v1-44109',
    storageBucket: 'fin-app-v1-44109.appspot.com',
    iosClientId:
        '887180827198-qfom1lu4pq1n42m5n9bovugsgilisd25.apps.googleusercontent.com',
    iosBundleId: 'com.example.finApp.RunnerTests',
  );
}
