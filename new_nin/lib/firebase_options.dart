// Minimal stub for `DefaultFirebaseOptions` so desktop builds don't fail.
// Replace this file with the real generated file from the
// FlutterFire CLI (`flutterfire configure`) when adding Firebase.
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: '',
      appId: '',
      messagingSenderId: '',
      projectId: '',
      authDomain: '',
      storageBucket: '',
      measurementId: '',
    );
  }
}
