import 'package:flutter/material.dart';
import 'package:mychat/service/authservice.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool visibility = false;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isNewUser = true;

  late Authservice _auth;

  @override
  void initState() {
    // TODO: implement initState
    // naruto@9tails.com
    // luffy@zmeat.com
    // onepiece1234

    super.initState();
    _auth = Authservice(name: _nameController.text);
  }

  void _register(String name) async {
    _auth = Authservice(name: name);
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await _auth.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() => _isLoading = false);
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await _auth.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      print('object');

      setState(() => _isLoading = false);
       print('object1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              Text(
                isNewUser ? "Create Account" : "Welcome Back!😁",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                isNewUser ? "Sign up to get started" : "Sign in to continue",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name Field
                    isNewUser
                        ? _buildTextField(
                            controller: _nameController,
                            label: "Full Name",
                            icon: Icons.person,
                            validator: (value) =>
                                value!.isEmpty ? "Enter your name" : null,
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 20),

                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.isEmpty ? "Enter a valid email" : null,
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    _buildTextField(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock,
                      isPassword: true,
                      obscureText: true,
                      validator: (value) => value!.length < 6
                          ? "Password must be 6+ chars"
                          : null,
                    ),
                    const SizedBox(height: 30),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                      onPressed:(){
                         isNewUser ? _register(_nameController.text) : _login();
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          shadowColor: Colors.blueAccent.withOpacity(0.3),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                isNewUser ? "Register" : "Login",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                           isNewUser ?"Already have an account?" :"Create new account!" ,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isNewUser = !isNewUser;
                            });
                          },
                          child:  Text(
                            isNewUser ?"Login" :"Register",
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        suffix: isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    visibility = !visibility;
                  });
                },
                child: visibility
                    ? const Icon(
                        Icons.visibility,
                      )
                    : const Icon(Icons.visibility_off))
            : const SizedBox.shrink(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      keyboardType: keyboardType,
      obscureText: isPassword ? visibility: obscureText,
      validator: validator,
    );
  }
}
