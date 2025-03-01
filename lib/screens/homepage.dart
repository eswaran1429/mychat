import 'package:flutter/material.dart';
import 'package:mychat/model/usermodel.dart';
import 'package:mychat/screens/chatscreen.dart';
import 'package:mychat/service/authservice.dart';
import 'package:mychat/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final currentuser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Chats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                '${currentuser!.email}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await Authservice(name: '').signout();
            },
            icon: const Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ],
      ),
      body: StreamBuilder<List<Usermodel>>(
        stream: Database(uid: currentuser.uid,).allUsers,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No Users',
                style: TextStyle(fontSize: 20),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = snapshot.data!;
          final data = user.where((data) => data.uid != currentuser.uid).toList();

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Chatscreen(
                      senderid: currentuser.uid,
                      receiverId: data[index].uid,
                      email: data[index].email,
                    ),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 25,
                        child: Text(
                          data[index].name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                            data[index].name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Tap to chat',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
