// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rent_ease/models/property_model.dart';
import 'reservation_form_UI.dart';

class AvailablePropertyDetailsUI extends StatefulWidget {
  final PropertyModel property;

  AvailablePropertyDetailsUI({required this.property});

  @override
  State<AvailablePropertyDetailsUI> createState() =>
      _AvailablePropertyDetailsUIState();
}

class _AvailablePropertyDetailsUIState
    extends State<AvailablePropertyDetailsUI> {
  final user = FirebaseAuth.instance.currentUser!;

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
                itemCount: widget.property.photoURLs.length,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(
                        widget.property.photoURLs[index]),
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
                    widget.property.propertyName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Description: ${widget.property.description}'),
                  SizedBox(height: 8),
                  Text('Location: ${widget.property.locationAddress}'),
                  SizedBox(height: 8),
                  Text('Rent Price: PHP ${widget.property.rentPrice}'),
                  // ... (other property details)
                  SizedBox(height: 8),
                  Text('Minimum Stay: ${widget.property.minStay} months'),

                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          bool isCurrentUserTenant =
                              await isUserTenant(user.uid);
                          if (isCurrentUserTenant) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'You are already a tenant of another property. You can no longer reserve other properties.',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      FilledButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            _navigateToReservationForm(context);
                          }
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
          property: widget.property,
        ),
      ),
    );
  }

  Future<bool> isUserTenant(String tenantID) async {
    CollectionReference properties =
        FirebaseFirestore.instance.collection('properties');
    QuerySnapshot propertyQuery =
        await properties.where('tenant', isEqualTo: tenantID).get();

    if (propertyQuery.size >= 1) {
      return true;
    }

    return false;
  }
}
