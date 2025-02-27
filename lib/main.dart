import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mychat/service/authservice.dart';
import 'package:mychat/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 if (kIsWeb) {
    await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: "AIzaSyCMMsv614G-v90pbvxWNLcb1yjD6FJEjD0",
  authDomain: "chat-3681b.firebaseapp.com",
  projectId: "chat-3681b",
  storageBucket: "chat-3681b.firebasestorage.app",
  messagingSenderId: "538254446573",
  appId: "1:538254446573:web:647f30f64e3ad989c1a1e4",
  measurementId: "G-0TPJL2S5S1"));
 } else {
   await Firebase.initializeApp();
 }


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Authservice(),
          child: const MyApp(),
        ),
       
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Wrapper(),
    );
  }
}
