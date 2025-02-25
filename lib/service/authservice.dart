import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychat/model/usermodel.dart';
class Authservice extends ChangeNotifier{
  final _auth = FirebaseAuth.instance;

  Usermodel? _currentUser;

  Usermodel? _userFromFirebase (User? user){
    return user != null ? Usermodel(uid: user.uid): null;
  }

  Usermodel? get currentUser => _currentUser; 

  Authservice() {
    _auth.authStateChanges().listen((User? user){
      _currentUser = _userFromFirebase(user);
      notifyListeners();
    });
  }

  Future anonymousLogin() async{
    try {
     UserCredential userCredential =  await _auth.signInAnonymously();
     print(userCredential);
     return userCredential;
    } catch (e) {
      print('error occured at $e');
    }
  }
  
  Future signout() async{
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}