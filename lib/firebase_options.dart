import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.`
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
    apiKey: 'AIzaSyBDjDH0sqsmSNAwSuwJNu7PM6r12XNH1k4',
    appId: '1:878439758236:web:a8b015d7c966cc4cf47059',
    messagingSenderId: '878439758236',
    projectId: 'final-mobile-b2d4c',
    authDomain: 'final-mobile-b2d4c.firebaseapp.com',
    storageBucket: 'final-mobile-b2d4c.firebasestorage.app',
    measurementId: 'G-2MHPXB3JTK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCxI0MVv_cuQJrZEqj7T9f9K2NF54v0-Qg',
    appId: '1:878439758236:android:aeccec5df7bafdd5f47059',
    messagingSenderId: '878439758236',
    projectId: 'final-mobile-b2d4c',
    storageBucket: 'final-mobile-b2d4c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAz7icJp53wXsqmKOp0GJ-VkJo8KtOka7U',
    appId: '1:878439758236:ios:f5e637a86123f68af47059',
    messagingSenderId: '878439758236',
    projectId: 'final-mobile-b2d4c',
    storageBucket: 'final-mobile-b2d4c.firebasestorage.app',
    iosBundleId: 'com.example.laporki',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAz7icJp53wXsqmKOp0GJ-VkJo8KtOka7U',
    appId: '1:878439758236:ios:f5e637a86123f68af47059',
    messagingSenderId: '878439758236',
    projectId: 'final-mobile-b2d4c',
    storageBucket: 'final-mobile-b2d4c.firebasestorage.app',
    iosBundleId: 'com.example.laporki',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBDjDH0sqsmSNAwSuwJNu7PM6r12XNH1k4',
    appId: '1:878439758236:web:10db0c6a4f976d2ef47059',
    messagingSenderId: '878439758236',
    projectId: 'final-mobile-b2d4c',
    authDomain: 'final-mobile-b2d4c.firebaseapp.com',
    storageBucket: 'final-mobile-b2d4c.firebasestorage.app',
    measurementId: 'G-1N9DHT3LWY',
  );
}
