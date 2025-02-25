import 'package:flutter/material.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Positioned(
          bottom: 10,
         
          child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder()
          ),
        ),)],
      ),
    );
  }
}
