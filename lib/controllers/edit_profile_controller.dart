// edit_profile_controller.dart

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_ease/models/user_model.dart';

class EditProfileController {
  late UserModel currentUser;
  File? image;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  void initialize() async {
    // Fetch the user data when the page is initialized
    final user_auth = FirebaseAuth.instance.currentUser!;
    currentUser = (await UserModel.getUserData(user_auth.uid))!; // Replace 'currentUserId' with the actual user ID
    // Set the initial values for text controllers
    firstNameController.text = currentUser.firstname;
    lastNameController.text = currentUser.lastname;
    phoneNumController.text = currentUser.phoneNum;
    usernameController.text = currentUser.username;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    // final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
  }

  Future<void> updateProfile(BuildContext context) async {
    // Update the user data in Firestore based on the changes made
    currentUser.firstname = firstNameController.text;
    currentUser.lastname = lastNameController.text;
    currentUser.phoneNum = phoneNumController.text;
    currentUser.username = usernameController.text;

    // Update the user profile picture if a new image is selected
    if (image != null) {
      // Implement code to upload the image to Firebase Storage and get the download URL
      // Update currentUser.profilePictureUrl with the new URL
    }

    // Save the updated user data to Firestore
    // For example, you can call a method in UserModel to update the data
    await currentUser.updateUserDataInFirestore(currentUser.userID);

    // Display a success message or navigate to another page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully!'),
      ),
    );
  }

  Future<void> updateUserProfilePicture(String profilePictureURL) async {
    try {
      // Update the user's profile picture URL in Firestore
      // await FirebaseFirestore.instance.collection('users').doc(currentUser.userID).update({
      //   'profilePictureURL': profilePictureURL,
      // });

      // Reference to the 'users' collection
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Use a where clause to filter documents based on the userID field
      QuerySnapshot userQuery = await users.where('userID', isEqualTo: currentUser.userID).get();

      // Check if there is exactly one matching document
      if (userQuery.size == 1) {
        // Update the user's profile picture URL in Firestore
        await users.doc(userQuery.docs[0].id).update({
          'profilePictureURL': profilePictureURL,
        });
      } else if (userQuery.size == 0) {
        // User document does not exist
        print('Error updating user data: User not found for auth UID: ${currentUser.userID}');
      } else {
        // Multiple documents found (unexpected), handle as needed
        print('Unexpected: Multiple documents found for auth UID: ${currentUser.userID}');
      }

      // Update the local user object
      currentUser = UserModel(
        userID: currentUser.userID,
        firstname: currentUser.firstname,
        lastname: currentUser.lastname,
        phoneNum: currentUser.phoneNum,
        username: currentUser.username,
        email: currentUser.email,
        password: currentUser.password,
        userType: currentUser.userType,
        profilePictureURL: profilePictureURL,
      );
    } catch (e) {
      // Handle the case when an error occurs during the Firestore update
      print('Error updating profile picture URL in Firestore: $e');
    }
  }
}
