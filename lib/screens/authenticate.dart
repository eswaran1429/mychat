import 'package:flutter/material.dart';
import 'package:mychat/service/authservice.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  final Authservice _auth = Authservice();
  String email = 'a@a.com';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () async{
              await _auth.anonymousLogin();
            }, child:Text('anonymous signin')),
               ElevatedButton(onPressed: () async{
              await _auth.register(email, 'password');
            }, child:Text('register')),
            ElevatedButton(onPressed: () async{
              await _auth.login(email, 'password');
            }, child:Text('login')),
          ],
        ),
      ),
    );
  }
}