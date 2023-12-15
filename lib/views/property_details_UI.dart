// property_details_UI.dart

// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rent_ease/controllers/property_controller.dart';
import 'package:rent_ease/models/property_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PropertyDetailsUI extends StatefulWidget {
  final PropertyModel property;

  const PropertyDetailsUI({Key? key, required this.property}) : super(key: key);

  @override
  _PropertyDetailsUIState createState() => _PropertyDetailsUIState();
}

class _PropertyDetailsUIState extends State<PropertyDetailsUI> {
  bool _isEditing = false;
  int _selectedImageIndex = 0; // Track the currently selected image
  late PageController _pageController;
  late TextEditingController _propertyNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationAddressController;
  late TextEditingController _rentPriceController;
  late TextEditingController _minStayController;
  late PropertyController _propertyController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedImageIndex);
    _propertyNameController =
        TextEditingController(text: widget.property.propertyName);
    _descriptionController =
        TextEditingController(text: widget.property.description);
    _locationAddressController =
        TextEditingController(text: widget.property.locationAddress);
    _rentPriceController =
        TextEditingController(text: widget.property.rentPrice.toString());
    _minStayController =
        TextEditingController(text: widget.property.minStay.toString());
    _propertyController =
        PropertyController(lessorId: widget.property.propertyOwner);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Property Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: _isEditing ? Icon(Icons.visibility) : Icon(Icons.edit),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSlider(widget.property.photoURLs),
              SizedBox(
                height: 15,
              ),
              _buildDetail('Property Name', _propertyNameController),
              _buildDetail('Description', _descriptionController),
              _buildDetail('Address', _locationAddressController),
              _buildDetail('Rent Price', _rentPriceController),
              _buildDetail('Minimum Duration of Stay', _minStayController),
              SizedBox(height: 15),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildImageSlider(List<String> photoURLs) {
  //   return Stack(
  //     children: [
  //       Container(
  //         height: 200,
  //         child: PageView.builder(
  //           controller: _pageController,
  //           itemCount: photoURLs.length,
  //           onPageChanged: (index) {
  //             setState(() {
  //               _selectedImageIndex = index;
  //             });
  //           },
  //           itemBuilder: (context, index) {
  //             return Image(
  //               image: CachedNetworkImageProvider(photoURLs[index]),
  //               fit: BoxFit.cover,
  //             );
  //           },
  //         ),
  //       ),
  //       if (_isEditing) _buildImageControls(photoURLs),
  //     ],
  //   );
  // }

  Widget _buildImageSlider(List<String> photoURLs) {
    return Stack(
      children: [
        Container(
          height: 200,
          child: PhotoViewGallery.builder(
            itemCount: photoURLs.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(photoURLs[index]),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              color: Colors.transparent,
            ),
            pageController: _pageController,
          ),
        ),
        if (_isEditing) _buildImageControls(photoURLs),
      ],
    );
  }

  Widget _buildImageControls(List<String> photoURLs) {
    return Positioned(
      bottom: 16,
      right: 1,
      child: Column(
        children: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.grey[600],
            ),
            onPressed: _isEditing ? () => _pickImage(photoURLs) : null,
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.grey[600],
            ),
            onPressed: _isEditing ? () => _removeImage(photoURLs) : null,
          ),
        ],
      ),
    );
  }

  void _pickImage(List<String> photoURLs) async {
    try {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File image = File(pickedFile.path);

        if (photoURLs.length < 8) {
          // Add the new image if the number of images is less than 8
          await _propertyController.addImageToProperty(
            propertyID: widget.property.propertyID,
            image: image,
          );
          setState(() {
            // Move to the last page after adding a new image
            _selectedImageIndex = photoURLs.length;
            _pageController.animateToPage(
              _selectedImageIndex,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        } else {
          // Show a message or notification that the maximum number of images has been reached
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Maximum number of images reached (8 images).')),
          );
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _removeImage(List<String> photoURLs) async {
    if (photoURLs.isNotEmpty) {
      await _propertyController.removeImageFromProperty(
        propertyID: widget.property.propertyID,
        imageIndex: _selectedImageIndex,
      );
      setState(() {
        // Move to the previous page after removing an image
        _selectedImageIndex =
            (_selectedImageIndex - 1).clamp(0, photoURLs.length - 1);
        _pageController.animateToPage(
          _selectedImageIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  Widget _buildDetail(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        _isEditing
            ? TextField(
                controller: controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
              )
            : Text(
                controller.text,
                style: TextStyle(fontSize: 16),
              ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSaveButton() {
    return _isEditing
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Save Changes'),
              ),
            ],
          )
        : Container();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() async {
    await _propertyController.updateProperty(
        propertyID: widget.property.propertyID,
        propertyName: _propertyNameController.text,
        description: _descriptionController.text,
        locationAddress: _locationAddressController.text,
        rentPrice: double.parse(_rentPriceController.text),
        minStay: int.parse(_minStayController.text));

    // Disable editing after saving changes
    _toggleEditMode();
  }
}
