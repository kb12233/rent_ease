// view_tenants_UI.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_ease/controllers/property_controller.dart';
import 'package:rent_ease/models/tenant_model.dart';
import 'package:rent_ease/views/view_tenant_details.dart';

class ViewTenantsUI extends StatefulWidget {
  ViewTenantsUI({super.key});

  @override
  _ViewTenantsUIState createState() => _ViewTenantsUIState();
}

class _ViewTenantsUIState extends State<ViewTenantsUI> {
  late Stream<List<TenantModel>> _tenantsStream;
  late PropertyController _propertyController;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _propertyController = PropertyController(lessorId: user.uid);
    _tenantsStream = _propertyController.getTenantsStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tenants'),
      ),
      body: StreamBuilder<List<TenantModel>>(
        stream: _tenantsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            var tenants = snapshot.data!;

            if (tenants.isEmpty) {
              return Center(
                child: Text('No tenants found.'),
              );
            }

            return ListView.builder(
              itemCount: tenants.length,
              itemBuilder: (context, index) {
                var tenant = tenants[index];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('${tenant.firstName} ${tenant.lastName}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Room: ${tenant.roomName}'),
                      ],
                    ),
                    onTap: () {
                      // Navigate to tenant details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewTenantDetailsPage(tenant: tenant),
                        ),
                      );
                    },
                    onLongPress: () {
                      // Long press action (if needed)
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}