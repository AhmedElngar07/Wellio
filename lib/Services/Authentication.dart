import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String name,
    required String gmail,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      if (name.isNotEmpty && gmail.isNotEmpty && password.isNotEmpty) {
        // Creating the user with the provided email and password
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: gmail,
          password: password,
        );

        // Saving additional user info in Firestore
        await _firestore.collection("users").doc(credential.user!.uid).set({
          "FullName": name,
          "Email": gmail,
          "uid": credential.user!.uid,
        });

        res = "success";
      } else {
        res = "All fields are required.";
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException Code: ${e.code}');
      print('FirebaseAuthException Message: ${e.message}');

      if (e.code == 'email-already-in-use') {
        res = "This email is already registered.";
      } else if (e.code == 'invalid-email') {
        res = "The email address is not valid.";
      } else if (e.code == 'weak-password') {
        res = "The password is too weak.";
      } else {
        res = "An unexpected error occurred: ${e.message}";
      }
    } catch (e) {
      print("General Error: ${e.toString()}");
      res = "An unexpected error occurred.";
    }

    return res;
  }

//for Login screen
  Future<String> loginUser(
      {required String gmail, required String password}) async {
    String res = "Some error occurred";

    try {
      if (gmail.isNotEmpty && password.isNotEmpty) {
        // Attempt to sign in with email and password
        await _auth.signInWithEmailAndPassword(
            email: gmail, password: password);
        res = "success";
      } else {
        res = "Please enter all fields.";
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuthException errors
      if (e.code == 'user-not-found') {
        res = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        res = "Incorrect password.";
      } else if (e.code == 'invalid-email') {
        res = "The email address is not valid.";
      } else {
        res = "An unexpected error occurred: ${e.message}";
      }
    } catch (e) {
      // Catch any general exceptions
      print("General Error: ${e.toString()}");
      res = "An unexpected error occurred.";
    }

    return res;
  }

  // log out

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>?> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user.uid).get();
      return snapshot.data() as Map<String, dynamic>?;
    }
    return null;
  }
}
