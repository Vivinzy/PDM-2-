// File generated from android/app/google-services.json.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return windows;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAMR5qv7EC20B2-C46Z9mhjIJBkVojbdyI',
    appId: '1:852222059625:android:bafaa06f01e6f2683d2ef8',
    messagingSenderId: '852222059625',
    projectId: 'cadastro-de-alunos-2e72b',
    storageBucket: 'cadastro-de-alunos-2e72b.firebasestorage.app',
  );
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBu2Kdx7UJ1Y-ku4URlCyKoxrD7ptIpIb0',
    appId: '1:852222059625:web:426e39600f809a9d3d2ef8',
    messagingSenderId: '852222059625',
    projectId: 'cadastro-de-alunos-2e72b',
    authDomain: 'cadastro-de-alunos-2e72b.firebaseapp.com',
    storageBucket: 'cadastro-de-alunos-2e72b.firebasestorage.app',
    measurementId: 'G-BKBPHPZXSP',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBu2Kdx7UJ1Y-ku4URlCyKoxrD7ptIpIb0',
    appId: '1:852222059625:web:ac1fb203e052d1893d2ef8',
    messagingSenderId: '852222059625',
    projectId: 'cadastro-de-alunos-2e72b',
    authDomain: 'cadastro-de-alunos-2e72b.firebaseapp.com',
    storageBucket: 'cadastro-de-alunos-2e72b.firebasestorage.app',
    measurementId: 'G-25VFRT0YKV',
  );
}
