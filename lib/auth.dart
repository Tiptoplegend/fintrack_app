import 'package:fintrack_app/Navigation.dart';
import 'package:fintrack_app/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUse() async {
    return auth.currentUser;
  }

 String getProfileImage(){
  var user = auth.currentUser;
  return user != null && user.photoURL != null
      ? user.photoURL!
      : "assets/images/user.png"; 
}
  signInwithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleUser?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication?.idToken,
      accessToken: googleSignInAuthentication?.accessToken,
    );

    UserCredential result = await firebaseAuth.signInWithCredential(credential);
    User? userDetails = result.user;

    Map<String, dynamic> userInfoMap = {
      "email": userDetails!.email,
      "name": userDetails.displayName,
      "imgurl": userDetails.photoURL,
      "id": userDetails.uid,
    };
    await DatabaseMethods().addUser(userDetails.uid, userInfoMap).then(
      (value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Navigation()),
        );
      },
    );
  }
}
