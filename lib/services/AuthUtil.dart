import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUtil {
 static Future resetpassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<AuthResult> signInUser(
    username,
    password,
  ) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: username, password: password)
        .then((value) {
      return value;
    });
  }

  static Future<AuthResult> registerUser(
    username,
    password,
  ) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: username, password: password)
        .then((value) {
      return value;
    });
  }

  static Future<FirebaseUser> getCurrentUser() async {
    final user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  static Future<bool> signOutCurrentUser() async {
    await FirebaseAuth.instance.signOut();
    return true;
  }

  static Future<DocumentSnapshot> getCurrentUserFromFS(
      FirebaseUser user) async {
    try {
      if (user != null) {
        print("user id is ${user.uid}");
        return Firestore.instance.collection('users').document(user.uid).get();
//            .then((ds) {
//          print("got user from fs ${ds["email"]}");
//          return ds;
//        });
      } else {
        print("user is null");
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
