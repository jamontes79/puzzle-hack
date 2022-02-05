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
        return macos;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCNmoEN-Km_NhkPDt1KI1mJuP-Y1469wU0',
    appId: '1:736252655924:web:34c0e07f089ac7fbff8d61',
    messagingSenderId: '736252655924',
    projectId: 'puzzlehack-jamontes79',
    authDomain: 'puzzlehack-jamontes79.firebaseapp.com',
    storageBucket: 'puzzlehack-jamontes79.appspot.com',
    measurementId: 'G-VPME2PCV8N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQ3AogJfKSbRuBwHzKKMYs42d3tGo2jOo',
    appId: '1:736252655924:android:74938adae559c61eff8d61',
    messagingSenderId: '736252655924',
    projectId: 'puzzlehack-jamontes79',
    storageBucket: 'puzzlehack-jamontes79.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDinLLTl82VsAuEzz-INxHUuDlMXbWNok',
    appId: '1:736252655924:ios:5a66fef953205ac2ff8d61',
    messagingSenderId: '736252655924',
    projectId: 'puzzlehack-jamontes79',
    storageBucket: 'puzzlehack-jamontes79.appspot.com',
    iosClientId: '736252655924-sdue4lmbc2ea7a6j1ceiea553ogmee4n.apps.googleusercontent.com',
    iosBundleId: 'xyz.albertomontesdeoca.puzzle.puzzle',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBDinLLTl82VsAuEzz-INxHUuDlMXbWNok',
    appId: '1:736252655924:ios:5a66fef953205ac2ff8d61',
    messagingSenderId: '736252655924',
    projectId: 'puzzlehack-jamontes79',
    storageBucket: 'puzzlehack-jamontes79.appspot.com',
    iosClientId: '736252655924-sdue4lmbc2ea7a6j1ceiea553ogmee4n.apps.googleusercontent.com',
    iosBundleId: 'xyz.albertomontesdeoca.puzzle.puzzle',
  );
}
