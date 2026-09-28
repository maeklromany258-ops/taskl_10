
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
    apiKey: 'AIzaSyBPUPyxhUj4JrIhs6gOyZ14On3pW3NRS8U',
    appId: '1:475044908524:web:9cb92b4e9edf68f8dfc4c9',
    messagingSenderId: '475044908524',
    projectId: 'feeddev-2ee75',
    authDomain: 'feeddev-2ee75.firebaseapp.com',
    storageBucket: 'feeddev-2ee75.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBk6kmnNhfC9_AHbkPzdoe6oSaTfvIXkq0',
    appId: '1:475044908524:android:7e302130032b377edfc4c9',
    messagingSenderId: '475044908524',
    projectId: 'feeddev-2ee75',
    storageBucket: 'feeddev-2ee75.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbYNSPZ4W32t30Xjc61MU0nswOE7rFyuk',
    appId: '1:475044908524:ios:b05f7d921d00fd53dfc4c9',
    messagingSenderId: '475044908524',
    projectId: 'feeddev-2ee75',
    storageBucket: 'feeddev-2ee75.firebasestorage.app',
    iosBundleId: 'com.example.ss20Firebase',
  );
}