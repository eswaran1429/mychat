import 'package:flutter/material.dart';
import 'package:mychat/model/usermodel.dart';
import 'package:mychat/screens/chatscreen.dart';
import 'package:mychat/service/authservice.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<List<Usermodel>>(context);
    final _currentuser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [IconButton(onPressed: ()async{
          await Authservice().signout();
        }, icon: const Icon(Icons.logout_outlined))],
      ),
      body: ListView.builder(
        itemCount: _user.length ,
        itemBuilder:(context,index){
         return InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Chatscreen(senderid: _currentuser!.uid,receiverId: _user[index].uid,)));
          },
           child: Card(
            elevation: 5,
             child: ListTile(
              title: Text(_user[index].uid),leading: const Icon(Icons.person),
             ),
           ),
         );
        } )
    );
  }
}