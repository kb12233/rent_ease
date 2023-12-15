// view_tenant_details.dart

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_ease/models/tenant_model.dart';
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewTenantDetailsPage extends StatelessWidget {
  final TenantModel tenant;

  ViewTenantDetailsPage({required this.tenant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tenant Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text('${tenant.firstName} ${tenant.lastName}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Room: ${tenant.roomName}'),
                    Row(
                      children: [
                        Text('Phone: '),
                        GestureDetector(
                          onTap: () {
                            Uri url = Uri.parse("tel://${tenant.phoneNumber}");
                            launchUrl(url);
                          },
                          child: Text(
                            tenant.phoneNumber,
                            style: TextStyle(
                              color: Colors.lightBlue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.lightBlue
                            ),
                          )
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            FlutterClipboard.copy(tenant.phoneNumber)
                            .then((value) => Fluttertoast.showToast(
                                msg: "Phone number copied to clipboard",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                            ));
                          },
                          child: Icon(
                            Icons.copy,
                            size: 15,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text('Email: '),
                        GestureDetector(
                          onTap: () {
                            Uri url = Uri.parse("mailto:${tenant.email}");
                            launchUrl(url);
                          },
                          child: Text(
                            tenant.email,
                            style: TextStyle(
                              color: Colors.lightBlue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.lightBlue
                            ),
                          )
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            FlutterClipboard.copy(tenant.email)
                            .then((value) => Fluttertoast.showToast(
                                msg: "Email copied to clipboard",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                            ));
                          },
                          child: Icon(
                            Icons.copy,
                            size: 15,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
