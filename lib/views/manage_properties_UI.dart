// manage_properties_UI.dart

// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, library_private_types_in_public_api, file_names

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_ease/controllers/property_controller.dart';
import 'package:rent_ease/models/property_model.dart';
import 'package:rent_ease/views/add_property_UI.dart';
import 'package:rent_ease/views/property_details_UI.dart';

class ManagePropertiesUI extends StatefulWidget {
  const ManagePropertiesUI({super.key});

  @override
  _ManagePropertiesUIState createState() => _ManagePropertiesUIState();
}

class _ManagePropertiesUIState extends State<ManagePropertiesUI> {
  late Stream<QuerySnapshot> _propertyStream;
  late PropertyController _propertyController;
  final user = FirebaseAuth.instance.currentUser!;
  final List<XFile> _selectedImages = [];

  final TextEditingController _propertyNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _locationAddressController =
      TextEditingController();
  final TextEditingController _rentPriceController = TextEditingController();
  final TextEditingController _minStayController = TextEditingController();

  // Track the current image index for each property
  Map<String, int> _currentImageIndices = {};

  @override
  void initState() {
    super.initState();
    _propertyController = PropertyController(lessorId: user.uid);
    _propertyStream = _propertyController.getPropertyStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _propertyStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var properties = _propertyController.mapProperties(snapshot.data!);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  var property = properties[index];

                  // Get the current image index for the property
                  int currentImageIndex = _currentImageIndices[property.propertyID] ?? 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: GestureDetector(
                      onTap: () => _navigateToPropertyDetails(property),
                      child: Card(
                        elevation: 0,
                        color: Colors.grey[200],
                        child: Column(
                          children: [
                            // Display images using PageView or placeholder
                            Stack(
                              children: [
                                Container(
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8.0),
                                      topLeft: Radius.circular(8.0)
                                    ),
                                    child: property.photoURLs.isNotEmpty
                                        ? PageView.builder(
                                            itemCount: property.photoURLs.length,
                                            itemBuilder: (context, imgIndex) {
                                              return Image(
                                                image: CachedNetworkImageProvider(property.photoURLs[imgIndex]),
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            onPageChanged: (imgIndex) {
                                              // Update the current image index
                                              setState(() {
                                                _currentImageIndices[property.propertyID] =
                                                    imgIndex;
                                              });
                                            },
                                          )
                                        : PlaceholderImage(), // Use a custom placeholder widget
                                  ),
                                ),
                                // Image index indicator
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: Colors.black54,
                                    ),
                                    child: Text(
                                      property.photoURLs.isNotEmpty
                                          ? 'Image ${currentImageIndex + 1}/${property.photoURLs.length}'
                                          : 'No Images',
                                      style: TextStyle(
                                        color: Colors.white,
                                        //backgroundColor: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ListTile(
                              title: Text(property.propertyName),
                              subtitle: Text('Rent Price: PHP ${property.rentPrice}'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteProperty(property),
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPropertyUI(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddPropertyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add New Property'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _propertyNameController,
                      decoration: InputDecoration(labelText: 'Property Name'),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                      controller: _locationAddressController,
                      decoration: InputDecoration(labelText: 'Address'),
                    ),
                    TextField(
                      controller: _rentPriceController,
                      decoration: InputDecoration(labelText: 'Rent Price'),
                      keyboardType: TextInputType.number,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        List<XFile>? images = await _pickMultipleImages();
                        setState(() {
                          _selectedImages.clear();
                          if (images != null) _selectedImages.addAll(images);
                        });
                      },
                      child: Text('Select Images'),
                    ),
                    SizedBox(height: 10),
                    if (_selectedImages.isNotEmpty)
                      Container(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Image.file(
                                    File(_selectedImages[index].path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.cancel),
                                      onPressed: () {
                                        setState(() {
                                          _selectedImages.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await _propertyController.addProperty(
                      propertyName: _propertyNameController.text,
                      description: _descriptionController.text,
                      locationAddress: _locationAddressController.text,
                      rentPrice: double.parse(_rentPriceController.text),
                      images: _selectedImages.map((file) => File(file.path)).toList(),
                      minStay: int.parse(_minStayController.text),
                    );

                    _propertyNameController.clear();
                    _descriptionController.clear();
                    _locationAddressController.clear();
                    _rentPriceController.clear();
                    _selectedImages.clear();

                    Navigator.pop(context);
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddPropertyUI(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPropertyUI()),
    );
  }


  void _deleteProperty(PropertyModel property) async {
    setState(() {
      _propertyController.removeProperty(property);
    });

    await FirebaseFirestore.instance
        .collection('properties')
        .doc(property.propertyID)
        .delete();
  }

  void _navigateToPropertyDetails(PropertyModel property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailsUI(property: property),
      ),
    );
  }

  Future<List<XFile>?> _pickMultipleImages() async {
    try {
      List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
      return pickedFiles;
    } catch (e) {
      print('Error picking images: $e');
      return null;
    }
  }

  Widget PlaceholderImage() {
    return Center(
      child: Icon(
        Icons.image,
        size: 100,
        color: Colors.grey,
      ),
    );
  }

}