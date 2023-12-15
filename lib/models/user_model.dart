import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userID;
  String firstname;
  String lastname;
  String phoneNum;
  String username;
  String email;
  String password;
  int userType;
  String profilePictureURL;

  UserModel({
    required this.userID,
    required this.firstname,
    required this.lastname,
    required this.phoneNum,
    required this.username,
    required this.email,
    required this.password,
    required this.userType,
    this.profilePictureURL = 'none'
  });

  // Static method to get user data from Firestore using userID
  static Future<UserModel?> getUserData(String userID) async {
    try {
      // Reference to the 'users' collection
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Use a where clause to filter documents based on the userID field
      QuerySnapshot userQuery =
          await users.where('userID', isEqualTo: userID).get();

      // Check if there is exactly one matching document
      if (userQuery.size == 1) {
        // Map the fields to create a UserModel object
        return UserModel(
          userID: userQuery.docs[0]['userID'],
          firstname: userQuery.docs[0]['firstname'],
          lastname: userQuery.docs[0]['lastname'],
          phoneNum: userQuery.docs[0]['phoneNum'],
          username: userQuery.docs[0]['username'],
          email: userQuery.docs[0]['email'],
          password: userQuery.docs[0]['password'],
          userType: userQuery.docs[0]['userType'],
          profilePictureURL: userQuery.docs[0]['profilePictureURL']
        );
      } else if (userQuery.size == 0) {
        // User document does not exist
        return null;
      } else {
        // Multiple documents found (unexpected), handle as needed
        print('Unexpected: Multiple documents found for userID: $userID');
        return null;
      }
    } catch (e) {
      // Handle errors, e.g., network issues, etc.
      print('Error getting user data: $e');
      return null;
    }
  }

  // Method to update user data in Firestore
  Future<void> updateUserDataInFirestore(String authUID) async {
    try {
      // Reference to the 'users' collection
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Use a where clause to filter documents based on the userID field
      QuerySnapshot userQuery =
          await users.where('userID', isEqualTo: authUID).get();

      // Check if there is exactly one matching document
      if (userQuery.size == 1) {
        // Update the document with the new user data
        await users.doc(userQuery.docs[0].id).update({
          'firstname': firstname,
          'lastname': lastname,
          'phoneNum': phoneNum,
          'username': username,
          // Add other fields as needed
        });
      } else if (userQuery.size == 0) {
        // User document does not exist
        print(
            'Error updating user data: User not found for auth UID: $authUID');
      } else {
        // Multiple documents found (unexpected), handle as needed
        print('Unexpected: Multiple documents found for auth UID: $authUID');
      }
    } catch (e) {
      // Handle errors, e.g., network issues, etc.
      print('Error updating user data: $e');
    }
  }
}
