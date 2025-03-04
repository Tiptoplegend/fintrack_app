import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack_app/Navigation.dart';
import 'package:fintrack_app/Onboarding/SignIn.dart';
import 'package:fintrack_app/Onboarding/Welcome.dart';
import 'package:fintrack_app/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordVisible = false;
  bool _isChecked = false; // Checkbox for Terms and Conditions
  bool _isLoading = false; // Global loading state

  String email = '', password = '', name = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Start Loading
  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  // Stop Loading
  void _stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  // Sign-Up with Email & Password
  Future<void> registration() async {
    if (!mounted) return;
    _startLoading();

    if (nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim());

        User? user = userCredential.user;

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .set({
          "email": user.email,
          "name": nameController.text.trim(),
          "uid": user.uid,
        });

        await userCredential.user
            ?.updateProfile(displayName: nameController.text.trim());
        await userCredential.user?.reload();

        if (mounted) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Navigation()));
        }
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        _stopLoading();

        String errorMessage = "An error occurred, please try again.";

        if (e.code == 'weak-password') {
          errorMessage = "Password provided is too weak.";
        } else if (e.code == "email-already-in-use") {
          errorMessage = "Account already exists.";
        } else {
          errorMessage = "Error: ${e.message}";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              errorMessage,
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      }
    }
  }

  // Google Sign-Up
  Future<void> googleSignIn() async {
    if (!mounted) return;
    _startLoading();

    try {
      await AuthMethods().signInwithGoogle(context);

      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Navigation()));
      }
    } catch (e) {
      if (!mounted) return;
      _stopLoading();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Google sign-in failed. Please try again.",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF005341), Color(0xFF43A047)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        if (_isLoading)
          _LoadingOverlay(), // Show loading overlay when signing up
      ],
    );
  }

  Widget _TextField(TextEditingController controller, String label) {
    return TextFormField(
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Please enter $label' : null,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Input
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        } else {
                          return null;
                        }
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        filled: true,
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                        floatingLabelStyle: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 22,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 0.3),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 0.3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 0.5, color: Colors.green),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Email Input
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please Enter your Email';
                        } else {
                          return null;
                        }
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                        floatingLabelStyle: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 22,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 0.3),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 0.3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 0.5, color: Colors.green),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Password Input
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please Enter your Password';
                        } else {
                          return null;
                        }
                      },
                      controller: passwordController,
                      obscureText: !_isPasswordVisible, // Toggle visibility
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                        floatingLabelStyle: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 22,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 0.3),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 0.3),
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
                                color: Colors.grey,
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
                        if (_formKey.currentState!.validate() && _isChecked) {
                          email = emailController.text;
                          password = passwordController.text;
                          name = nameController.text;

                          registration(); // Call the registration function
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Please complete the form and accept the terms.",
                              style: TextStyle(fontSize: 18),
                            ),
                          ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.green[600],
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
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: "Login",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
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
                        AuthMethods().signInwithGoogle(context);
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
          ),
          if (_isLoading)
            _LoadingOverlay(), // Show loading overlay when signing up
        ],
      ),
    );
  }

  // Removed unused _TextField method

  // Removed unused _PasswordField method

  // Removed unused _TermsCheckbox method


  // Removed unused _LoginLink method



  Widget _LoadingOverlay() {
    return Container(
        color: Colors.black.withOpacity(0.6),
        child: Center(child: CircularProgressIndicator(color: Colors.white)));
  }
}
