// add_property_UI.dart

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_ease/controllers/property_controller.dart';
import 'package:rent_ease/models/user_model.dart';
import 'package:rent_ease/views/lessor_home_UI.dart';
import 'package:rent_ease/views/manage_properties_UI.dart';

class AddPropertyUI extends StatefulWidget {
  @override
  _AddPropertyUIState createState() => _AddPropertyUIState();
}

class _AddPropertyUIState extends State<AddPropertyUI> {
  final TextEditingController _propertyNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationAddressController =
      TextEditingController();
  final TextEditingController _rentPriceController = TextEditingController();
  final TextEditingController _minStayController = TextEditingController(); // Add this line
  late PropertyController _propertyController;
  final user = FirebaseAuth.instance.currentUser!;
  final List<XFile> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _propertyController = PropertyController(lessorId: user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Property'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            TextField(
              controller: _minStayController,
              decoration: InputDecoration(labelText: 'Minimum Stay'),
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
              Expanded(
                child: Container(
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
                                color: Colors.red,
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
              ),
            _buildSavePropertyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSavePropertyButton() {
    return ElevatedButton(
      onPressed: () async {
        // Show loading dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator());
          },
        );

        try {
          // Add the property
          await _propertyController.addProperty(
            propertyName: _propertyNameController.text,
            description: _descriptionController.text,
            locationAddress: _locationAddressController.text,
            rentPrice: _rentPriceController.text.isEmpty
                ? 0.0
                : double.tryParse(_rentPriceController.text) ?? 0.0,
            images: _selectedImages.map((file) => File(file.path)).toList(),
            minStay: int.parse(_minStayController.text),
          );

          // Hide loading dialog
          Navigator.pop(context);

          // Show success dialog
          _showSuccessDialog();

          // Navigate back to ManagePropertiesUI
          _navigateToManageProperties();
        } catch (e) {
          // Hide loading dialog
          Navigator.pop(context);

          // Handle error
          print('Error adding property: $e');

          // Show error dialog or message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to add property. Please try again.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Text('Save Property'),
    );
  }



  Future<void> _showSuccessDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('The new property was successfully added.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToManageProperties() async {
    final user_auth = FirebaseAuth.instance.currentUser!;
    UserModel? user = await UserModel.getUserData(user_auth.uid);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LessorHomeUI(user: user!)),
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
}
