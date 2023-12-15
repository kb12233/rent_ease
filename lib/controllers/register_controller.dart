import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class RegisterControl {
  static Future<void> addToDb(
    String userID, // Added parameter
    String firstname,
    String lastname,
    String phoneNum,
    String username,
    String email,
    String password,
    int userType, // Added parameter
  ) async {
    await FirebaseFirestore.instance.collection('users').add({
      'userID': userID, // Set user ID in the database
      'firstname': firstname,
      'lastname': lastname,
      'phoneNum': phoneNum,
      'username': username,
      'email': email,
      'password': password,
      'userType': userType, // Set user type in the database
      // Add other fields as needed
    });
  }

  static Future<String?> signUp(
    String firstname,
    String lastname,
    String phoneNum,
    String username,
    String email,
    String password,
    int userType, // Added parameter
  ) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Call the addToDb function with the user ID and user type
      await addToDb(
        userCredential.user!.uid,
        firstname,
        lastname,
        phoneNum,
        username,
        email,
        password,
        userType,
      );

      return "Success";
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return e.message;
    }
  }
}
