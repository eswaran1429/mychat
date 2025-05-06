import 'package:flutter/material.dart';
import 'package:mychat/screens/authenticate.dart';
import 'package:mychat/screens/homepage.dart';
import 'package:mychat/service/authservice.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Authservice>(context);
    return StreamBuilder(
        stream: Stream.value(user.currentUser),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snap.hasData) {
            return const Homepage();
          } else {
            return const Authenticate();
          }
        });
  }
}
