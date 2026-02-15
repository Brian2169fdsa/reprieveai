import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAFI7f1diTJ7-f5K0OqCIzBkwX8E2g8ogI",
            authDomain: "newfreedom-637b5-7c3c3.firebaseapp.com",
            projectId: "newfreedom-637b5-7c3c3",
            storageBucket: "newfreedom-637b5-7c3c3.firebasestorage.app",
            messagingSenderId: "34301966281",
            appId: "1:34301966281:web:f132f462bf7be27d8a1a18",
            measurementId: "G-BLCQTZK4J7"));
  } else {
    await Firebase.initializeApp();
  }
}
