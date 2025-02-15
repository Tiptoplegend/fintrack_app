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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBRavvp1iUL7iNncucP6nzHWYkKlkkV9qQ',
    appId: '1:296412863207:web:495a2fb460a77d5034a042',
    messagingSenderId: '296412863207',
    projectId: 'fintrack-c708a',
    authDomain: 'fintrack-c708a.firebaseapp.com',
    storageBucket: 'fintrack-c708a.firebasestorage.app',
    measurementId: 'G-WVC32L4819',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBbKyMeb4_ckq6lM5ju1DhHBzDTEKORWGg',
    appId: '1:296412863207:android:cf837e11a098a4c834a042',
    messagingSenderId: '296412863207',
    projectId: 'fintrack-c708a',
    storageBucket: 'fintrack-c708a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCULOCtZ2N8IvOPX2M1mCQ_UCb2c5sdmuo',
    appId: '1:296412863207:ios:1746c1b69ec445cf34a042',
    messagingSenderId: '296412863207',
    projectId: 'fintrack-c708a',
    storageBucket: 'fintrack-c708a.firebasestorage.app',
    iosBundleId: 'com.example.fintrackApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCULOCtZ2N8IvOPX2M1mCQ_UCb2c5sdmuo',
    appId: '1:296412863207:ios:1746c1b69ec445cf34a042',
    messagingSenderId: '296412863207',
    projectId: 'fintrack-c708a',
    storageBucket: 'fintrack-c708a.firebasestorage.app',
    iosBundleId: 'com.example.fintrackApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBRavvp1iUL7iNncucP6nzHWYkKlkkV9qQ',
    appId: '1:296412863207:web:01ec7b146bb4a8ef34a042',
    messagingSenderId: '296412863207',
    projectId: 'fintrack-c708a',
    authDomain: 'fintrack-c708a.firebaseapp.com',
    storageBucket: 'fintrack-c708a.firebasestorage.app',
    measurementId: 'G-WV5RWL5RXD',
  );
}
