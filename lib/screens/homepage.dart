import 'package:flutter/material.dart';
import 'package:mychat/service/authservice.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [IconButton(onPressed: ()async{
          await Authservice().signout();
        }, icon: const Icon(Icons.logout_outlined))],
      ),
      body: const Center(
        child: Text('homepage'),
      ),
    );
  }
}