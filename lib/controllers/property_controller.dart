// property_controller.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:rent_ease/models/property_model.dart';
import 'package:rent_ease/models/tenant_model.dart';

class PropertyController {
  final String lessorId;

  PropertyController({required this.lessorId});

  Stream<QuerySnapshot> getAvailablePropertiesStream() {
    return FirebaseFirestore.instance
        .collection('properties')
        .where('tenant',
            isEqualTo: 'none') // Filter properties without a tenant
        .orderBy('propertyName', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getPropertyStream() {
    return FirebaseFirestore.instance
        .collection('properties')
        .where('propertyOwner', isEqualTo: lessorId)
        .orderBy('propertyName', descending: false)
        .snapshots();
  }

  Future<void> addProperty({
    required String propertyName,
    required String description,
    required String locationAddress,
    required dynamic rentPrice,
    required List<File> images, // Add this parameter for image files
    required int minStay,
  }) async {
    try {
      CollectionReference properties =
          FirebaseFirestore.instance.collection('properties');

      // Add a new property with a generated document ID
      await properties.add({
        'propertyOwner': lessorId,
        'propertyName': propertyName,
        'description': description,
        'locationAddress': locationAddress,
        'rentPrice': rentPrice,
        'tenant': 'none',
        'propertyID': '',
        'photoURLs': List.filled(8, ''), // Initialize with 8 empty strings
        'minStay': minStay,
      }).then((newProperty) async {
        // Update the propertyID field with the document ID
        await newProperty.update({'propertyID': newProperty.id});

        // Upload property images to Firebase Storage
        await _uploadPropertyImages(newProperty.id, images);

        // Update the property's photoURLs with the download URLs
        List<String> photoURLs = await _getUploadedPhotoURLs(newProperty.id);
        await newProperty.update({'photoURLs': photoURLs});
      });
    } catch (e) {
      print('Error adding property: $e');
    }
  }

  Future<void> removeProperty(PropertyModel property) async {
    try {
      // Delete property images from Firebase Storage
      await _deletePropertyImages(property.propertyID);

      // Delete property document from Firestore
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(property.propertyID)
          .delete();
    } catch (e) {
      print('Error deleting property: $e');
    }
  }

  Future<void> updateProperty({
    required String propertyID,
    required String propertyName,
    required String description,
    required String locationAddress,
    required dynamic rentPrice,
    List<File>? images, // Add this parameter for image files
    required int minStay,
  }) async {
    try {
      CollectionReference properties =
          FirebaseFirestore.instance.collection('properties');

      // Update the property details
      await properties.doc(propertyID).update({
        'propertyName': propertyName,
        'description': description,
        'locationAddress': locationAddress,
        'rentPrice': rentPrice,
        'minStay': minStay,
      });

      // Update property images if new images are provided
      if (images != null) {
        // Delete existing property images from Firebase Storage
        await _deletePropertyImages(propertyID);

        // Upload new property images to Firebase Storage
        await _uploadPropertyImages(propertyID, images);

        // Update the property's photoURLs with the download URLs
        List<String> photoURLs = await _getUploadedPhotoURLs(propertyID);
        await properties.doc(propertyID).update({'photoURLs': photoURLs});
      }
    } catch (e) {
      print('Error updating property: $e');
    }
  }

  Future<void> _uploadPropertyImages(
      String propertyID, List<File> images) async {
    try {
      for (int i = 0; i < images.length && i < 8; i++) {
        File image = images[i];
        String imagePath = 'property_images/$propertyID/photo_$i.jpg';
        firebase_storage.Reference storageReference =
            firebase_storage.FirebaseStorage.instance.ref().child(imagePath);
        await storageReference.putFile(image);
      }
    } catch (e) {
      print('Error uploading property images: $e');
    }
  }

  Future<void> _uploadPropertyImage(
      String propertyID, int imageIndex, File image) async {
    try {
      String imagePath = 'property_images/$propertyID/photo_$imageIndex.jpg';
      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(imagePath);
      await storageReference.putFile(image);
    } catch (e) {
      print('Error uploading property image: $e');
    }
  }

  Future<void> addImageToProperty({
    required String propertyID,
    required File image,
  }) async {
    try {
      List<String> photoURLs = await _getUploadedPhotoURLs(propertyID);

      if (photoURLs.length < 8) {
        // Upload the new image to Firebase Storage
        await _uploadPropertyImage(propertyID, photoURLs.length, image);

        // Update the property's photoURLs with the download URLs
        List<String> updatedPhotoURLs = await _getUploadedPhotoURLs(propertyID);
        await FirebaseFirestore.instance
            .collection('properties')
            .doc(propertyID)
            .update({'photoURLs': updatedPhotoURLs});
      }
    } catch (e) {
      print('Error adding image to property: $e');
    }
  }

  Future<List<String>> _getUploadedPhotoURLs(String propertyID) async {
    List<String> photoURLs = [];

    try {
      for (int i = 0; i < 8; i++) {
        String imagePath = 'property_images/$propertyID/photo_$i.jpg';
        firebase_storage.Reference storageReference =
            firebase_storage.FirebaseStorage.instance.ref().child(imagePath);

        try {
          // Attempt to get the download URL
          String downloadURL = await storageReference.getDownloadURL();
          photoURLs.add(downloadURL);
        } catch (e) {
          // If the image doesn't exist, use a placeholder URL or an empty string
          // photoURLs.add('https://example.com/placeholder.jpg');
          continue;
        }
      }
    } catch (e) {
      print('Error getting photo URLs: $e');
    }

    return photoURLs;
  }

  Future<void> _deletePropertyImages(String propertyID) async {
    try {
      for (int i = 0; i < 8; i++) {
        String imagePath = 'property_images/$propertyID/photo_$i.jpg';
        firebase_storage.Reference storageReference =
            firebase_storage.FirebaseStorage.instance.ref().child(imagePath);
        await storageReference.delete();
      }
    } catch (e) {
      print('Error deleting property images: $e');
    }
  }

  Future<void> _deletePropertyImage(String propertyID, int imageIndex) async {
    try {
      String imagePath = 'property_images/$propertyID/photo_$imageIndex.jpg';
      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(imagePath);
      await storageReference.delete();
    } catch (e) {
      print('Error deleting property image: $e');
    }
  }

  // Original code for removeImageFromProperty
  // Future<void> removeImageFromProperty({
  //   required String propertyID,
  //   required int imageIndex,
  // }) async {
  //   try {
  //     List<String> photoURLs = await _getUploadedPhotoURLs(propertyID);

  //     if (imageIndex >= 0 && imageIndex < photoURLs.length) {
  //       // Delete the image from Firebase Storage
  //       await _deletePropertyImage(propertyID, imageIndex);

  //       // Update the property's photoURLs after removing the image
  //       List<String> updatedPhotoURLs = await _getUploadedPhotoURLs(propertyID);
  //       await FirebaseFirestore.instance
  //           .collection('properties')
  //           .doc(propertyID)
  //           .update({'photoURLs': updatedPhotoURLs});

  //       // TODO Rename files in storage
  //       // put code here
  //     }
  //   } catch (e) {
  //     print('Error removing image from property: $e');
  //   }
  // }

  Future<void> removeImageFromProperty({
    required String propertyID,
    required int imageIndex,
  }) async {
    try {
      List<String> photoURLs = await _getUploadedPhotoURLs(propertyID);

      if (imageIndex >= 0 && imageIndex < photoURLs.length) {
        // Delete the image from Firebase Storage
        await _deletePropertyImage(propertyID, imageIndex);

        // Rename remaining files in storage
        await renameRemainingFiles(propertyID, imageIndex, photoURLs.length);

        // Update the property's photoURLs after removing 
        // the image and renaming the remaning files
        List<String> updatedPhotoURLs = await _getUploadedPhotoURLs(propertyID);
        await FirebaseFirestore.instance
            .collection('properties')
            .doc(propertyID)
            .update({'photoURLs': updatedPhotoURLs});
      }
    } catch (e) {
      print('Error removing image from property: $e');
    }
  }

  /// Renames remaining files in storage after deleting an image and deletes the original reference.
  Future<void> renameRemainingFiles(
    String propertyID, 
    int deletedImageIndex, 
    int endIndex
    ) async {
    for (int i = deletedImageIndex + 1; i < endIndex; i++) {
      final String originalPath = 'property_images/$propertyID/photo_$i.jpg';
      final String newPath = 'property_images/$propertyID/photo_${i - 1}.jpg';

      final originalRef = 
        firebase_storage.FirebaseStorage.instance.ref().child(originalPath);
      final newRef =
        firebase_storage.FirebaseStorage.instance.ref().child(newPath);

      // Download the file to a temporary file
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      File tempFile = await File('$tempPath/tempImage.jpg').create();

      try {
        // Download the file
        await originalRef.writeToFile(tempFile);

        // Rename the file (upload to new location)
        await newRef.putFile(tempFile);

        // Delete the original file
        await originalRef.delete();
      } finally {
        tempFile.deleteSync();
      }
    }
  }

  List<PropertyModel> mapProperties(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;

      // Extract photo URLs from data or initialize an empty list
      List<String> photoURLs =
          List.from(data['photoURLs'] ?? List.filled(8, ''));

      return PropertyModel(
        propertyID: data['propertyID'],
        propertyOwner: data['propertyOwner'],
        propertyName: data['propertyName'],
        description: data['description'],
        locationAddress: data['locationAddress'] ?? '',
        rentPrice: data['rentPrice'],
        tenant: data['tenant'],
        photoURLs: photoURLs,
        minStay: data['minStay'] ?? 0,
      );
    }).toList();
  }

  Stream<List<TenantModel>> getTenantsStream() {
    return FirebaseFirestore.instance
        .collection('properties')
        .where('propertyOwner', isEqualTo: lessorId)
        .where('tenant', isNotEqualTo: 'none')
        .snapshots()
        .asyncMap((snapshot) async {
      List<TenantModel> tenants = [];

      for (var property in snapshot.docs) {
        var tenantID = property['tenant'];

        if (tenantID != null && tenantID != 'none') {
          // Fetch tenant details from the 'user' collection
          var tenantSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('userID', isEqualTo: tenantID)
              .get();

          var tenantData = tenantSnapshot.docs[0].data();

          // Fetch room name, phone number, and email from the property
          var roomName = property['propertyName'] ?? 'Unknown Room';
          var phoneNumber = tenantData['phoneNum'] ?? 'No phone number';
          var email = tenantData['email'] ?? 'No email';

          tenants.add(TenantModel(
            userID: tenantData['userID'],
            firstName: tenantData['firstname'],
            lastName: tenantData['lastname'],
            roomName: roomName,
            phoneNumber: phoneNumber,
            email: email,
          ));
        }
      }

      return tenants;
    });
  }
}
