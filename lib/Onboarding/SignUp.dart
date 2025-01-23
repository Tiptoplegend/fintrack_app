import 'package:fintrack_app/Onboarding/SignIn.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordVisible = false; // Initial state: Password is hidden
  bool _isChecked = false; // Track the checkbox state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'inter',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Input
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  filled: true,
                  fillColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  floatingLabelStyle: TextStyle(
                    fontFamily: 'inter',
                    fontSize: 22,
                    color: Colors.green,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(width: 0.1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(width: 0.1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(width: 0.5, color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Email Input
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  floatingLabelStyle: TextStyle(
                    fontFamily: 'inter',
                    fontSize: 22,
                    color: Colors.green,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(width: 0.1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(width: 0.1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(width: 0.5, color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Password Input
              TextField(
                obscureText: !_isPasswordVisible, // Toggle visibility
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  floatingLabelStyle: TextStyle(
                    fontFamily: 'inter',
                    fontSize: 22,
                    color: Colors.green,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(width: 0.1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(width: 0.1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(width: 0.5, color: Colors.green),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Terms Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "By signing up, you agree to the ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "Terms of Service and Privacy Policy",
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle Terms click
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Sign-Up Button
              ElevatedButton(
                onPressed: () {
                  // Handle sign-up logic
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF005341),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'inter',
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Login Link
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration:
                                TextDecoration.underline, // Underline the text
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle Login click
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signin()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Or",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              SizedBox(height: 30),

              // Google Sign-In Button
              ElevatedButton.icon(
                onPressed: () {
                  // Handle Google sign-in logic
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.grey,
                    width: 0.1,
                  ),
                ),
                icon: SizedBox(
                  width: 33,
                  height: 33,
                  child: Image.asset('assets/google_icon0.png'),
                ),
                label: Text(
                  "Continue with Google",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'inter',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
