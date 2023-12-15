// available_properties_UI.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_ease/controllers/property_controller.dart';
import 'package:rent_ease/models/property_model.dart';
import 'package:rent_ease/views/available_property_details_UI.dart';

class AvailablePropertiesUI extends StatefulWidget {
  @override
  _AvailablePropertiesUIState createState() => _AvailablePropertiesUIState();
}

class _AvailablePropertiesUIState extends State<AvailablePropertiesUI> {
  late Stream<QuerySnapshot> _availablePropertiesStream;
  late PropertyController _propertyController;
  final String lessorID = 'your_lessor_id_here';

  TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  Map<String, int> _currentImageIndices = {};

  @override
  void initState() {
    super.initState();
    _propertyController = PropertyController(lessorId: lessorID);
    _availablePropertiesStream =
        _propertyController.getAvailablePropertiesStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by Name or Location',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _updateSearch('');
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  _updateSearch(value);
                },
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _availablePropertiesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  var availableProperties = _propertyController
                      .mapProperties(snapshot.data!)
                      .where((property) =>
                        property.propertyName
                          .toLowerCase()
                          .contains(_searchTerm.toLowerCase()) ||
                        property.locationAddress
                          .toLowerCase()
                          .contains(_searchTerm.toLowerCase())).toList();

                  return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: availableProperties.length,
                        itemBuilder: (context, index) {
                          var property = availableProperties[index];

                          // Get the current image index for the property
                          int currentImageIndex =
                              _currentImageIndices[property.propertyID] ?? 0;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: GestureDetector(
                              onTap: () => _navigateToPropertyDetails(property),
                              child: Card(
                                elevation: 0,
                                color: Colors.grey[200],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Display images using PageView or placeholder
                                    Stack(
                                      children: [
                                        Container(
                                          height: 200,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.only(
                                                  topRight: Radius.circular(8.0),
                                                  topLeft: Radius.circular(8.0)
                                                ),
                                            child: property.photoURLs.isNotEmpty
                                                ? PageView.builder(
                                                    itemCount:
                                                      property.photoURLs.length,
                                                    itemBuilder:
                                                      (context, imgIndex) {
                                                        return Image(
                                                          image: CachedNetworkImageProvider(property.photoURLs[imgIndex]),
                                                          fit: BoxFit.cover,
                                                        );
                                                        // return CachedNetworkImage( // try this
                                                        //   imageUrl: property.photoURLs[imgIndex],
                                                        //   placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                        //   errorWidget: (context, url, error) => Icon(Icons.error),
                                                        // );
                                                      },
                                                    onPageChanged: (imgIndex) {
                                                      // Update the current image index
                                                      setState(() {
                                                        _currentImageIndices[property.propertyID] = imgIndex;
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
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListTile(
                                      title: Text(
                                        property.propertyName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Description: ${property.description}\nLocation: ${property.locationAddress}\nRent Price: PHP ${property.rentPrice}',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateSearch(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
    });
  }

  void _navigateToPropertyDetails(PropertyModel property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AvailablePropertyDetailsUI(property: property),
      ),
    );
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
