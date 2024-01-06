// edit_profile_UI.dart

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_ease/controllers/edit_profile_controller.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:rent_ease/models/user_model.dart';

class EditProfileUI extends StatefulWidget {
  final UserModel user;
  
  const EditProfileUI({required this.user});

  @override
  _EditProfileUIState createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  late EditProfileController _controller;
  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFile; // To store the selected image file
  String _profilePictureURL = ''; // To store the profile picture URL
  final user_auth = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _fetchProfilePictureURL();
    _controller = EditProfileController();
    _controller.initialize();
    //_loadProfilePicture(); // Load the profile picture when the page is initialized
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Edit Profile'),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           CircleAvatar(
  //             radius: 60,
  //             backgroundImage: _controller.image != null
  //             ? FileImage(_controller.image!)
  //             : AssetImage('lib/images/tenant.png') as ImageProvider<Object>, // Provide your default image path
  //           ),
  //           SizedBox(height: 16),
  //           ElevatedButton(
  //             onPressed: () => _controller.pickImage(),
  //             child: Text('Change Profile Picture'),
  //           ),
  //           SizedBox(height: 16),
  //           _buildTextField('First Name', _controller.firstNameController),
  //           _buildTextField('Last Name', _controller.lastNameController),
  //           _buildTextField('Phone Number', _controller.phoneNumController),
  //           _buildTextField('Username', _controller.usernameController),
  //           SizedBox(height: 16),
  //           ElevatedButton(
  //             onPressed: () => _controller.updateProfile(context),
  //             child: Text('Save Changes'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _fetchProfilePictureURL() async {
    // Fetch the profile picture URL from Firestore and update _profilePictureURL
    // Replace 'users', 'userId', and 'profilePictureURL' with your actual collection name, user ID, and field name

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot userQuery =
        await users.where('userID', isEqualTo: user_auth.uid).get();
    // final doc = await FirebaseFirestore.instance.collection('users').doc('userId').get();
    if (mounted) {
      setState(() {
        _profilePictureURL = userQuery.docs[0]['profilePictureURL'];
      });
    }
  }

  Future<void> _uploadProfilePicture() async {
    try {
      // Use the user's auth UID to uniquely identify their profile picture
      String profilePicturePath =
          'profile_pictures/${_controller.currentUser.userID}.jpg';

      // Reference to the profile picture in Firebase Storage
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child(profilePicturePath);

      // Upload the selected image file to Firebase Storage
      await storageReference.putFile(_imageFile!);

      // Retrieve the download URL for the uploaded profile picture
      String profilePictureURL = await storageReference.getDownloadURL();

      // Update the user's profile picture URL in Firestore
      await _controller.updateUserProfilePicture(profilePictureURL);

      setState(() {
        _profilePictureURL = profilePictureURL;
      });
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
  }

  Future<void> _loadProfilePicture() async {
    try {
      // Use the user's auth UID to uniquely identify their profile picture
      String profilePicturePath =
          'profile_pictures/${_controller.currentUser.userID}.jpg';

      // Reference to the profile picture in Firebase Storage
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child(profilePicturePath);

      // Get the download URL for the profile picture
      String profilePictureURL = await storageReference.getDownloadURL();

      setState(() {
        // Load the profile picture using Image.network
        _imageFile = null; // Clear any local image file
        _profilePictureURL = profilePictureURL;
      });
    } catch (e) {
      // Handle the case when the profile picture doesn't exist or an error occurs
      print('Error loading profile picture: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
    _uploadProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              widget.user.profilePictureURL.isNotEmpty ?
                CircleAvatar(
                  radius: 50,
                  // Display the profile picture or a default image/icon
                  backgroundImage: CachedNetworkImageProvider(_profilePictureURL)
                ) :

                CircleAvatar(
                  radius: 50,
                  // Display the profile picture or a default image/icon
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                )
              //CachedNetworkImageProvider(property.photoURLs[imgIndex])
              ,
              //CachedNetworkImageProvider(property.photoURLs[imgIndex])

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 125),
                child: FilledButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: _uploadProfilePicture,
              //   child: Text('Upload Profile Picture'),
              // ),

              // Add other text fields for firstname, lastname, phoneNum, and username
              // Add a Save button to call _controller.updateUserData

              const SizedBox(height: 16),
              _buildTextField('First Name', _controller.firstNameController),
              _buildTextField('Last Name', _controller.lastNameController),
              _buildTextField('Phone Number', _controller.phoneNumController),
              _buildTextField('Username', _controller.usernameController),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 120),
                child: FilledButton(
                  onPressed: () {
                    _controller.updateProfile(context);
                  },
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
