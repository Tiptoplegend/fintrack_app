import 'package:fintrack_app/Forgetpassword.dart';
import 'package:fintrack_app/Navigation.dart';
import 'package:fintrack_app/Onboarding/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool _isPasswordVisible = false; // State for password visibility
  String email = '';
  String password = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Navigation()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "No user Found for that Email",
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Wrong password Provided by user",
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Inter',
            color: Colors.black,
          ),
        ),
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
                _LoginButton(),
                const SizedBox(height: 5),
                _ForgotPassword(),
                const SizedBox(height: 20),
                _Account_yet(),
                const SizedBox(height: 30),
                _Continue(),
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
          fontFamily: 'Inter',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _Text() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Let’s get you back to managing your finances.',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _EmailField() {
    return TextFormField(
      controller: emailController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please Enter Email';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        labelText: 'Email',
        filled: true,
        fillColor: Colors.grey[200],
        labelStyle: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: 'Inter',
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
    );
  }

  Widget _Password() {
    return TextFormField(
      controller: passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter your Password';
        } else {
          return null;
        }
      },

      obscureText: !_isPasswordVisible, // Toggles password visibility
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.grey[200],
        labelStyle: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: 'Inter',
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
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _LoginButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle login logic
        if (_formKey.currentState!.validate()) {
          email = emailController.text;
          password = passwordController.text;
          userLogin();
        }
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: const Color(0xFF005341),
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
              color: Colors.black,
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
    // Google Sign-In Button
    return ElevatedButton.icon(
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
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
