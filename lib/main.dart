import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mychat/model/usermodel.dart';
import 'package:mychat/service/authservice.dart';
import 'package:mychat/service/database.dart';
import 'package:mychat/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
         ChangeNotifierProvider(
      create: (context) => Authservice(),
      child: const MyApp(),
    ),
        StreamProvider<List<Usermodel>>.value(
          value: Database(uid: 'uid').allUsers,  
          initialData: [],             
          catchError: (_, __) => [],   
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
      home: Wrapper(),
    );
  }
}
