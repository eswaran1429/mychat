import 'package:flutter/material.dart';
import 'package:mychat/model/usermodel.dart';
import 'package:mychat/service/authservice.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<List<Usermodel>>(context) ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [IconButton(onPressed: ()async{
          await Authservice().signout();
        }, icon: const Icon(Icons.logout_outlined))],
      ),
      body: ListView.builder(
        itemCount: _user.length ?? 0 ,
        itemBuilder:(context,index){
         return Card(
          elevation: 5,
           child: ListTile(
            title: Text(_user[index].uid),leading: Icon(Icons.person),
           ),
         );
        } )
    );
  }
}