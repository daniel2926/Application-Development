import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pad_1/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
   User? _user;

  User? get user => _user;


  void loadUser() {
    _user = _auth.currentUser;
    notifyListeners();
  }
    void sendPasswordResetEmail(String email) async {
  await _auth.sendPasswordResetEmail(email: email);
}

  Future<bool> signIn(String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    loadUser();
    return true;
  } catch (e) {
    print('Sign-in error: $e');
    return false;
  }
}

Future<bool> signUp(String email, String password, String name, String nickname) async {
  try {
    final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await createUserDocument(userCredential.user!, name, nickname);
    return true;
  } catch (e) {
    print('Sign-up error: $e');
    return false;
  }
}

Future<void> createUserDocument(User user, String name, String nickname) async {
  final userDoc = {
    'userId': user.uid,
    'email': user.email,
    'name': name,
    'nickname': nickname,
    'createdAt': FieldValue.serverTimestamp(),
    'profileImage': '',
    'favorites':<String>[]
  };
  await FirebaseFirestore.instance.collection('users').doc(user.uid).set(userDoc);
}

Future<void> signOut() async {
  await _auth.signOut();
  loadUser();
  print('User signed out.');
}

Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('Google Sign-In canceled.');
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        final user = userCredential.user!;
        await user.reload();
        if (!user.emailVerified) {
          await user.sendEmailVerification();
          print('Google email not verified. Verification email sent.');
          await _auth.signOut();
          return false;
        }

        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await createUserDocument(user, user.displayName ?? "No Name", "");
        }

        loadUser();
        return true;
      }
      return false;
    } catch (e) {
      print('Google Sign-In error: $e');
      return false;
    }
  }

}