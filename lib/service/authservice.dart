import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychat/model/usermodel.dart';
import 'package:mychat/service/database.dart';

class Authservice extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final String name;

  Usermodel? _currentUser;

  Usermodel? _userFromFirebase(User? user) {
    return user != null ? Usermodel(uid: user.uid, email: user.email ?? 'no email',name: name) : null;
  }

  Usermodel? get currentUser => _currentUser;

  Authservice({required this.name}) {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = _userFromFirebase(user);
      notifyListeners();
    });
  }

  Future anonymousLogin() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      Database().addUser(currentUser!.uid, currentUser!.email,name);
      return userCredential;
    } catch (e) {
      print('error occured at $e');
    }
  }

  Future register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      Database().addUser(currentUser!.uid,currentUser!.email,name);
      return userCredential;
    } catch (e) {
      print('error occured at $e');
    }
  }

   Future login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      print('error occured at $e');
    }
  }

  Future signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
