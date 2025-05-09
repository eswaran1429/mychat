import 'package:flutter/material.dart';
import 'package:mychat/model/usermodel.dart';
import 'package:mychat/screens/add_contacts.dart';
import 'package:mychat/screens/chatscreen.dart';
import 'package:mychat/screens/profilepage.dart';
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
    Database database = Database();
    String? profile;
    Future<String?> getProfile(String userId) async {
      profile = await database.getProfile(userId);
      return profile;
    }

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.blueAccent,
              child: Center(
                  child: Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
              )),
            ),
            Card(
              elevation: 2,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                },
                child: const ListTile(
                  title: Text('Settings'),
                ),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Chats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
            child: const Icon(Icons.settings),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                currentuser!.email![0].toUpperCase(),
                style: const TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await Authservice(name: 'no name').signout();
            },
            icon: const Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/background1.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          StreamBuilder<List<Usermodel>>(
            stream: Database().getcontacts(),
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
              final userData =
                  user.where((data) => data.uid != currentuser.uid).toList();

              return ListView.builder(
                itemCount: userData.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Chatscreen(
                          senderid: currentuser.uid,
                          receiverId: userData[index].uid,
                          name: userData[index].name,
                        ),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: Container(
                                            height: 300,
                                            width: 300,
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                            child: FutureBuilder<String?>(
                                                future: getProfile(
                                                    userData[index].uid),
                                                builder:
                                                    (context, profileSnapshot) {
                                                  if (profileSnapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator(
                                                      value: 10,
                                                    );
                                                  }
                                                  final url = profileSnapshot
                                                          .data ??
                                                      'https://res.cloudinary.com/dfc5mnnqi/image/upload/v1742883154/mn7egacupkxgelkiycfa.png';
                                                  return Image.network(
                                                    url,
                                                    fit: BoxFit.contain,
                                                  );
                                                })),
                                      );
                                    });
                              },
                              child: FutureBuilder(
                                  future: getProfile(userData[index].uid),
                                  builder: (context, snap) {
                                    if (snap.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.blueAccent,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2),
                                      );
                                    }

                                    final url = snap.data;
                                    if (url != null && url.isNotEmpty) {
                                      return CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(url),
                                        backgroundColor: Colors.transparent,
                                      );
                                    } else {
                                      return const CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.blue,
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.black,
                                        ),
                                      );
                                    }
                                  })),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData[index].name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.black,),
        onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddContactScreen()));
      }),
    );
  }
}
