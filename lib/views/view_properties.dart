// view_properties_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_ease/controllers/property_controller.dart';
import 'package:rent_ease/models/property_model.dart';
import 'package:rent_ease/views/available_property_details_UI.dart';

class ViewProperties extends StatefulWidget {
  @override
  _ViewPropertiesState createState() => _ViewPropertiesState();
}

class _ViewPropertiesState extends State<ViewProperties> {
  late Stream<QuerySnapshot> _availablePropertiesStream;
  late PropertyController _propertyController;
  final String lessorID = 'your_lessor_id_here'; // Replace with your lessor ID

  @override
  void initState() {
    super.initState();
    _propertyController = PropertyController(lessorId: lessorID);
    _availablePropertiesStream = _propertyController.getAvailablePropertiesStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Properties'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _availablePropertiesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var availableProperties = _propertyController.mapProperties(snapshot.data!);

            return ListView.builder(
              itemCount: availableProperties.length,
              itemBuilder: (context, index) {
                var property = availableProperties[index];

                return Card(
                  child: ListTile(
                    title: Text(property.propertyName),
                    subtitle: Text(
                      'Description: ${property.description}\nRent Price: PHP ${property.rentPrice}',
                    ),
                    onTap: () => _navigateToPropertyDetails(property),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _navigateToPropertyDetails(PropertyModel property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AvailablePropertyDetailsUI(property: property),
      ),
    );
  }
}
