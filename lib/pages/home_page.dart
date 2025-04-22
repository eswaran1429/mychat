import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mychat/pages/login_page.dart';

class HomePage extends StatelessWidget {
  final GoogleSignInAccount user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white, // White background
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          title: Text('Profile',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold)), // Changed to Profile
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  user.photoUrl ?? '',
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            children: <Widget>[
              _buildWelcomeMessage(), // Welcome message like the login page
              SizedBox(height: 30),
              _buildUserInfo(),
              SizedBox(height: 30),
              _buildActionButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Welcome message similar to the login page
  Widget _buildWelcomeMessage() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(seconds: 1),
        child: Text(
          'Welcome, ${user.displayName}!',
          style: TextStyle(
            // Use Google Font
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Change text color to black
            letterSpacing: 1.5, // Letter spacing for better visual
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 4,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // User info displayed in a ListTile format
  Widget _buildUserInfo() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.person, color: Colors.blueAccent),
          title: Text(
            'Name',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(user.displayName ?? 'N/A'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.email, color: Colors.blueAccent),
          title: Text(
            'Email',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(user.email ?? 'N/A'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.account_circle, color: Colors.blueAccent),
          title: Text(
            'ID',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(user.id),
        ),
      ],
    );
  }

  // Logout button
  Widget _buildActionButton(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          backgroundColor:
              Colors.grey[400], // Button color similar to login page
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          shadowColor: Colors.black.withOpacity(0.3),
          elevation: 10,
        ),
        onPressed: () async {
          final GoogleSignIn googleSignIn = GoogleSignIn();

          try {
            // Sign out and disconnect
            await googleSignIn.signOut(); // Sign out from Google
            await googleSignIn.disconnect(); // Disconnect Google Sign-In to clear any session cache
            print("Sign out successful");
          } catch (error) {
            print('Error during sign out: $error');
          }
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) =>
                  LoginPage())); // Navigate back to login page
        },
        child: Text(
          'Logout',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
