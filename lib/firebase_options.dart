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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA-bSK2jjG_aShbfxOttdjb69wdBynLYqg',
    appId: '1:1024108467361:web:fc5effa0e0e57e0a3b8ce0',
    messagingSenderId: '1024108467361',
    projectId: 'medease-1f1df',
    authDomain: 'medease-1f1df.firebaseapp.com',
    storageBucket: 'medease-1f1df.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA14Y0H65_Kx1u5v54fgljCxudZcRLrI_I',
    appId: '1:1024108467361:android:e07d79ab088272293b8ce0',
    messagingSenderId: '1024108467361',
    projectId: 'medease-1f1df',
    storageBucket: 'medease-1f1df.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDVpGvd-5Vrc3ikjrGT2XB8s7fRTb7xQ1g',
    appId: '1:1024108467361:ios:4d1ec9223ede9d473b8ce0',
    messagingSenderId: '1024108467361',
    projectId: 'medease-1f1df',
    storageBucket: 'medease-1f1df.appspot.com',
    iosClientId: '1024108467361-m0o150nvf1a82e1hupkeltjes5s9qfam.apps.googleusercontent.com',
    iosBundleId: 'com.dukoSolutions.medEase',
  );
}
