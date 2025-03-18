import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pad_1/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:renew_market/datas/mock_user.dart';

class UserProvider with ChangeNotifier {
  // UserModel _user = mockUser;
  // // UserModel get user => _user;

  // // UserModel _user = loadUser() as UserModel;
  // UserModel get user => _user;

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel _user = UserModel(
    userId: '',
    name: '',
    email: '',
    profileImage: '',
    joinedDate: Timestamp.now(),
    favorites: [],
     nickname: '',
  );



  UserModel get user => _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void addFavorite(String postId) {
    // Add implementation
    user.favorites.add(postId);
    notifyListeners();
  }

  void removeFavorite(String postId) {
    // Add implementation
    user.favorites.remove(postId);
    notifyListeners();
  }

Future<void> loadUser() async {
  final firebaseUser = _auth.currentUser;
  if (firebaseUser != null) {
    print("User is logged in: ${firebaseUser.uid}");
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists) {
        print("Raw Firestore Data: ${doc.data()}"); // Debugging log
        _user = UserModel.fromJson(doc.data()!);
      } else {
        // If the user document does not exist, create it from FirebaseAuth details
        _user = UserModel(
          userId: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'Unknown User',
          email: firebaseUser.email ?? '',
          profileImage: firebaseUser.photoURL ?? '',
          joinedDate: Timestamp.now(),
          favorites: [], 
          nickname: firebaseUser.displayName ?? 'Unknown User',
        );

        // Save user to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set(_user.toJson());
      } 
      notifyListeners();
    } catch (e) {
      print('Error loading user: $e');
    }
  } else {
    print('No user is currently logged in.');
  }
}


Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return false; // User canceled sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? firebaseUser = authResult.user;

      if (firebaseUser != null) {
        _user = UserModel(
          userId: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          profileImage: firebaseUser.photoURL ?? '',
          joinedDate: Timestamp.now(),
          favorites: [], nickname: firebaseUser.displayName ?? '',
        );

        // Check if user already exists in Firestore
        DocumentSnapshot doc =
            await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();

        if (!doc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
            "userId": firebaseUser.uid,
            "name": firebaseUser.displayName ?? '',
            "nickname": firebaseUser.displayName ?? '',
            "email": firebaseUser.email ?? '',
            "profileImage": firebaseUser.photoURL ?? '',
            "joinedDate": Timestamp.now(),
            "favorites": [],
          });
        }

        notifyListeners();
        return true;
      }
    } catch (e) {
      print("Google Sign-In failed: $e");
    }
    return false;
  }

}