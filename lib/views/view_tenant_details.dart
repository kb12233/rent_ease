// view_tenant_details.dart

// ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:rent_ease/models/tenant_model.dart';
// import 'package:clipboard/clipboard.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ViewTenantDetailsPage extends StatelessWidget {
//   final TenantModel tenant;

//   ViewTenantDetailsPage({required this.tenant});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tenant Details'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: ListTile(
//                 title: Text('${tenant.firstName} ${tenant.lastName}'),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Room: ${tenant.roomName}'),
//                     Row(
//                       children: [
//                         Text('Phone: '),
//                         GestureDetector(
//                           onTap: () {
//                             Uri url = Uri.parse("tel://${tenant.phoneNumber}");
//                             launchUrl(url);
//                           },
//                           child: Text(
//                             tenant.phoneNumber,
//                             style: TextStyle(
//                               color: Colors.lightBlue,
//                               decoration: TextDecoration.underline,
//                               decorationColor: Colors.lightBlue
//                             ),
//                           )
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             FlutterClipboard.copy(tenant.phoneNumber)
//                             .then((value) => Fluttertoast.showToast(
//                                 msg: "Phone number copied to clipboard",
//                                 toastLength: Toast.LENGTH_SHORT,
//                                 gravity: ToastGravity.BOTTOM,
//                             ));
//                           },
//                           child: Icon(
//                             Icons.copy,
//                             size: 15,
//                           ),
//                         )
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Text('Email: '),
//                         GestureDetector(
//                           onTap: () {
//                             Uri url = Uri.parse("mailto:${tenant.email}");
//                             launchUrl(url);
//                           },
//                           child: Text(
//                             tenant.email,
//                             style: TextStyle(
//                               color: Colors.lightBlue,
//                               decoration: TextDecoration.underline,
//                               decorationColor: Colors.lightBlue
//                             ),
//                           )
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             FlutterClipboard.copy(tenant.email)
//                             .then((value) => Fluttertoast.showToast(
//                                 msg: "Email copied to clipboard",
//                                 toastLength: Toast.LENGTH_SHORT,
//                                 gravity: ToastGravity.BOTTOM,
//                             ));
//                           },
//                           child: Icon(
//                             Icons.copy,
//                             size: 15,
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



//WORKINGG!!
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_ease/models/tenant_model.dart';
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewTenantDetailsPage extends StatelessWidget {
  final TenantModel tenant;

  ViewTenantDetailsPage({required this.tenant});

  // Step 1: Declare the controller
  final TextEditingController _dueDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tenant Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Existing Tenant Card
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

              // New Card for Setting Monthly Rent
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Tenant\'s Monthly Rent here',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                       SizedBox(height: 8),
                      Text(
                        'Ex: January Rent + Electricity(1000) + Water(200)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 16),
                      // Step 2: Use the controller for the Due Date field
                      TextField(
                        controller: _dueDateController,
                        decoration: InputDecoration(
                          labelText: 'Due Date',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                _dueDateController.text = "${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.year.toString()}";
                              }
                            },
                            icon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'You may add fees for utilities',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Electricity (Optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Water (Optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          // Logic to set monthly rent
                          Fluttertoast.showToast(
                            msg: "Monthly rent set!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                        },
                        child: Text('Set Monthly Rent'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to launch URL
  launchUrl(Uri url) async {
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      Fluttertoast.showToast(
        msg: "Failed to launch URL",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
