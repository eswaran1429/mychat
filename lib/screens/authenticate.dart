import 'package:flutter/material.dart';
import 'package:mychat/service/authservice.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  final Authservice _auth = Authservice();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () async{
          await _auth.anonymousLogin();
        }, child:Text('anonymous signin')),
      ),
    );
  }
}