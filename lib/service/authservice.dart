import 'package:firebase_auth/firebase_auth.dart';

class Authservice {
  final _auth = FirebaseAuth.instance;

  Future anonymousLogin() async{
    try {
     UserCredential userCredential =  await _auth.signInAnonymously();
     print(userCredential);
     return userCredential;
    } catch (e) {
      print('error occured at $e');
    }
  }
}