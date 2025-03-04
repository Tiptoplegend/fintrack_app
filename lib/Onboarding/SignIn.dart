import 'package:fintrack_app/Forgetpassword.dart';
import 'package:fintrack_app/Navigation.dart';
import 'package:fintrack_app/Onboarding/SignUp.dart';
import 'package:fintrack_app/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool _isPasswordVisible = false; // Password visibility state
  bool _isLoading = false; // Global loading state
  String email = '';
  String password = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

  // Sign in with Email & Password
  Future<void> userLogin() async {
    if (!mounted) return;
    _startLoading(); // Start loading animation

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Navigation()));
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      _stopLoading(); // Stop loading if error occurs

      String errorMessage = "An error occurred, please try again.";

      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided.";
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

  // Google Sign-In with Unified Loading State
  Future<void> googleSignIn() async {
    if (!mounted) return;
    _startLoading(); // Start loading animation

    try {
      await AuthMethods().signInwithGoogle(context);

      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Navigation()));
      }
    } catch (e) {
      if (!mounted) return;

      _stopLoading(); // Stop loading if error occurs

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
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF005341), Color(0xFF43A047)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Login',
              style: TextStyle(
                  fontSize: 24, fontFamily: 'Inter', color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    _WelcomeText(),
                    const SizedBox(height: 2),
                    _Text(),
                    const SizedBox(height: 30),
                    _EmailField(),
                    const SizedBox(height: 30),
                    _Password(),
                    const SizedBox(height: 30),
                    _LoginButton(), // Login button
                    const SizedBox(height: 5),
                    _ForgotPassword(),
                    const SizedBox(height: 20),
                    _Account_yet(),
                    const SizedBox(height: 30),
                    _Continue(), // Google Sign-In button
                  ],
                ),
              ),
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Inter',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      // Removed duplicate body parameter
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    _WelcomeText(),
                    const SizedBox(height: 2),
                    _Text(),
                    const SizedBox(height: 30),
                    _EmailField(),
                    const SizedBox(height: 30),
                    _Password(),
                    const SizedBox(height: 30),
                    _LoginButton(),
                    const SizedBox(height: 5),
                    _ForgotPassword(),
                    const SizedBox(height: 20),
                    _Account_yet(),
                    const SizedBox(height: 30),
                    _Continue(),
                  ],
                ),
                if (_isLoading)
                  _LoadingOverlay(), // Show loading overlay when signing in
              ],
            ),
          ),
        ),
    ),
    );
  }

  Widget _WelcomeText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Welcome Back!',
        style: TextStyle(
            fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _Text() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Let’s get you back to managing your finances.",
        style: TextStyle(fontFamily: 'Inter', fontSize: 16),
      ),
    );
  }

  Widget _EmailField() {
    return TextFormField(
      controller: emailController,
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Please Enter Email' : null,
      decoration: InputDecoration(
        labelText: 'Email',
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _Password() {
    return TextFormField(
      controller: passwordController,
      validator: (value) => value == null || value.trim().isEmpty
          ? 'Please Enter your Password'
          : null,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        suffixIcon: IconButton(
          icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () =>
              setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
    );
  }

  Widget _LoginButton() {
return ElevatedButton(
  onPressed: _isLoading
      ? null
      : () {
          if (_formKey.currentState!.validate()) {
            email = emailController.text.trim();
            password = passwordController.text.trim();
            userLogin();
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
    "Login",
    style: TextStyle(
      fontSize: 18,
      fontFamily: 'Inter',
      color: Colors.white,
    ),
  ),
);
  }

  Widget _ForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Handle the forgot password logic
        },
        child: RichText(
          text: TextSpan(
            text: 'Forgot Password?',
            style: TextStyle(
              color: Colors.blue, // Change to your desired color
              fontFamily: 'Inter',
              fontSize: 14,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Handle Forgot Password click
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Forgetpassword(),
                    ));
              },
          ),
        ),
      ),
    );
  }

  Widget _Account_yet() {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Navigate to login screen
        },
        child: RichText(
          text: TextSpan(
            text: "Don't have an account yet? ",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            children: [
              TextSpan(
                text: "Sign up",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Handle Sign up click
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _Continue() {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : googleSignIn,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.grey, width: 0.1),
      ),
      icon: Image.asset('assets/google_icon0.png', width: 33, height: 33),
      label: Text("Continue with Google",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontFamily: 'Inter')),
    );
  }

  Widget _LoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
