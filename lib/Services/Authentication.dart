import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser(
      {required String name,
      required String gmail,
      required String password}) async {
    String res = "Some error occurred";

    try {
      if (name.isNotEmpty || gmail.isNotEmpty || password.isNotEmpty) {
        // Creating the user with the provided email and password
        //for register user in firebase auth with email and password
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: gmail, password: password);

        // Saving additional user info in Firestore
        await _firestore.collection("users").doc(credential.user!.uid).set(
            {"FullName": name, "Email": gmail, "uid": credential.user!.uid});

        res = "success";
      }
    } catch (e) {
      // Print and capture the error message
      print("Error: ${e.toString()}");
      res = e.toString(); // Return the error message
    }

    return res; // Return the result (either success or error message)
  }

//for LOgin screen
  Future<String> loginUser(
      {required String gmail, required String password}) async {
    String res = "Some error occurred";

    try {
      if (gmail.isNotEmpty || password.isNotEmpty) {
        //login user with email and password
        await _auth.signInWithEmailAndPassword(
            email: gmail, password: password);
        res = "success";
      } else {
        res = "please enter all field";
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      res = e.toString();
    }
    return res;
  }

  // log out

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
