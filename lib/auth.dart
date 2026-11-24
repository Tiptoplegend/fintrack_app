import 'package:fintrack_app/database.dart';
import 'package:fintrack_app/debug_log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// iOS OAuth client from [GoogleService-Info.plist] `CLIENT_ID`.
const _iosGoogleClientId =
    '296412863207-sdi6tkb697mn2fiib7h1k3igrmssbmdg.apps.googleusercontent.com';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUse() async {
    return auth.currentUser;
  }

  String getProfileImage() {
    var user = auth.currentUser;
    return user != null && user.photoURL != null
        ? user.photoURL!
        : "assets/images/user.png";
  }

  /// Completes Google + Firebase sign-in. Caller handles navigation on success.
  Future<void> signInwithGoogle(BuildContext context) async {
    final useIosClientId =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    appLog(
      'Google: starting sign-in '
      '(platform=$defaultTargetPlatform, iosClientId=$useIosClientId)',
    );

    try {
      final googleSignIn = GoogleSignIn(
        clientId: useIosClientId ? _iosGoogleClientId : null,
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        appLog('Google: user cancelled sign-in');
        throw Exception('Google sign-in was cancelled');
      }
      appLog('Google: account selected email=${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;
      appLog(
        'Google: tokens idToken=${idToken != null}, '
        'accessToken=${accessToken != null}',
      );
      if (idToken == null && accessToken == null) {
        throw Exception('Google did not return sign-in tokens');
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      appLog('Firebase: signInWithCredential');
      final UserCredential result = await auth.signInWithCredential(credential);
      final User? userDetails = result.user;
      if (userDetails == null) {
        throw Exception('Firebase sign-in failed');
      }
      appLog('Firebase: signed in uid=${userDetails.uid}');

      final Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "name": userDetails.displayName,
        "imgurl": userDetails.photoURL,
        "id": userDetails.uid,
      };

      appLog('Firestore: saving user profile');
      await DatabaseMethods().addUser(userDetails.uid, userInfoMap);
      appLog('Google: sign-in flow completed');
    } on FirebaseAuthException catch (e, st) {
      appLog(
        'Google/Firebase auth failed',
        error: '${e.code}: ${e.message}',
        stackTrace: st,
      );
      rethrow;
    } catch (e, st) {
      appLog('Google sign-in failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}