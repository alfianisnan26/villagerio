import 'package:firebase_core/firebase_core.dart' as core;

class Firebase {
  static initializeApp() async {
    await core.Firebase.initializeApp(options: const core.FirebaseOptions(
          apiKey: "AIzaSyBNDNWOQKw7U5FEbnv3atxz_Gf21Dw3u0g",
          authDomain: "villagerio.firebaseapp.com",
          databaseURL: "https://villagerio-default-rtdb.asia-southeast1.firebasedatabase.app",
          projectId: "villagerio",
          storageBucket: "villagerio.appspot.com",
          messagingSenderId: "322656423412",
          appId: "1:322656423412:web:df1037b22ae7f6e5dbbda1",
          measurementId: "G-BLLDSGR904",
    ));
  }
}