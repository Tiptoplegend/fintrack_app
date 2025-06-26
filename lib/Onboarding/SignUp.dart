import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack_app/Navigation.dart';
import 'package:fintrack_app/Onboarding/SignIn.dart';
import 'package:fintrack_app/Onboarding/Welcome.dart';
import 'package:fintrack_app/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return Stack(
      children: [
        Scaffold(
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
            title: Text(
              'Sign Up',
              style: TextStyle(
                  fontSize: 24, fontFamily: 'inter', color: Colors.white),
            ),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Welcomepage()));
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _TextField(nameController, "Name"),
                    SizedBox(height: 30),
                    _TextField(emailController, "Email"),
                    SizedBox(height: 30),
                    _PasswordField(),
                    SizedBox(height: 30),
                    // _TermsCheckbox(),
                    // SizedBox(height: 30),
                    _SignUpButton(),
                    SizedBox(height: 30),
                    _LoginLink(),
                    SizedBox(height: 30),
                    _Divider(),
                    SizedBox(height: 30),
                    _GoogleSignInButton(),
                  ],
                ),
              ),
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
    );
  }

  Widget _PasswordField() {
    return TextFormField(
      controller: passwordController,
      validator: (value) => value == null || value.trim().isEmpty
          ? 'Please enter your Password'
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

  // Widget _TermsCheckbox() {
  //   return Row(
  //     children: [
  //       Checkbox(
  //         value: _isChecked,
  //         onChanged: (value) => setState(() => _isChecked = value ?? false),
  //         activeColor: Colors.black,
  //       ),
  //       Expanded(
  //         child: Text(
  //             "By signing up, you agree to the Terms of Service and Privacy Policy."),
  //       ),
  //     ],
  //   );
  // }

  Widget _SignUpButton() {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () {
              if (_formKey.currentState!.validate() ) {
                email = emailController.text.trim();
                password = passwordController.text.trim();
                name = nameController.text.trim();
                registration();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text("Please complete the form and accept the terms."),
                ));
              }
            },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Colors.green[600],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child:
          Text("Sign Up", style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  Widget _LoginLink() {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Signin())),
      child: Text("Already have an account? Login",
          style: TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline)),
    );
  }

  Widget _Divider() {
    return Row(children: [
      Expanded(child: Divider()),
      Text(" Or "),
      Expanded(child: Divider())
    ]);
  }

  Widget _GoogleSignInButton() {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : googleSignIn,
      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
      icon: Image.asset('assets/google_icon0.png', width: 33, height: 33),
      label: Text("Continue with Google"),
    );
  }

  Widget _LoadingOverlay() {
    return Container(
        color: Colors.black.withOpacity(0.6),
        child: Center(child: CircularProgressIndicator(color: Colors.white)));
  }
}
