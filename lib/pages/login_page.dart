import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_page.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    // Remove the signInSilently() call to ensure the app doesn't log the user in automatically.
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Solid White Background
            Container(
              color: Colors.white, // Change background to white
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo with Animation
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(seconds: 1),
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/google2.jpg'), // Update with your logo
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    // Welcome Text with more styling
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(seconds: 1),
                      child: Text(
                        'Hello, Let\'s Get Started!',
                        style: TextStyle( // Use Google Font
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
                    SizedBox(height: 40),
                    // Google Sign In Button with Animation
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          shadowColor: Colors.blueAccent,
                          elevation: 5,
                        ),
                        onPressed: _handleSignIn,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/google.jpg', // Your Google icon here
                              height: 40,
                              width: 40,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Terms & Conditions Text
                    RichText(
                      text: TextSpan(
                        text: 'By signing in, you agree to our ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms & Conditions.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueAccent,
                            ),
                          )
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 Future<void> _handleSignIn() async {
  try {
    if (_googleSignIn.currentUser != null) {
      // Sign out if already signed in
      await _googleSignIn.signOut();
    }

    final account = await _googleSignIn.signIn();
    if (account != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(user: account),
        ),
      );
    }
  } catch (error) {
    print('Error occurred: $error');
  }
}

}
