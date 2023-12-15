import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rent_ease/models/property_model.dart';
import 'reservation_form_UI.dart';

class AvailablePropertyDetailsUI extends StatelessWidget {
  final PropertyModel property;

  AvailablePropertyDetailsUI({required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container for images (replace with ImageSlider)
            Container(
              height: 200,
              child: PhotoViewGallery.builder(
                itemCount: property.photoURLs.length,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(property.photoURLs[index]),
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                scrollPhysics: BouncingScrollPhysics(),
                backgroundDecoration: BoxDecoration(
                  color: Colors.black,
                ),
                pageController: PageController(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.propertyName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Description: ${property.description}'),
                  SizedBox(height: 8),
                  Text('Location: ${property.locationAddress}'),
                  SizedBox(height: 8),
                  Text('Rent Price: PHP ${property.rentPrice}'),
                  // ... (other property details)
                  SizedBox(height: 8),
                  Text('Minimum Stay: ${property.minStay} months'),

                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _navigateToReservationForm(context);
                        },
                        child: Text('Reserve'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToReservationForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationFormUI(
          property: property,
        ),
      ),
    );
  }
}
