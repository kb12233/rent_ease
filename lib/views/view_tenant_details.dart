// view_tenant_details.dart

// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_ease/controllers/payment_controller.dart';
import 'package:rent_ease/models/payment_model.dart';
import 'package:rent_ease/models/tenant_rent_details.dart';
import 'package:clipboard/clipboard.dart';
import 'package:rent_ease/models/user_model.dart';
import 'package:rent_ease/views/lessor_home_UI.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewTenantDetailsPage extends StatefulWidget {
  final TenantRentDetails tenant;

  ViewTenantDetailsPage({required this.tenant});

  @override
  _ViewTenantDetailsPageState createState() => _ViewTenantDetailsPageState();
}

class _ViewTenantDetailsPageState extends State<ViewTenantDetailsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _electricityController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;

  late PaymentController _paymentController;

  double _total = 0.0;
  late DateTime picked_date;
  late DateTime selectedStartDate;

  @override
  void initState() {
    _total = widget.tenant.rentPrice;
    picked_date = DateTime.now();
    selectedStartDate = DateTime.now();
    _paymentController = PaymentController();
  }

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
                  title: Text(
                    '${widget.tenant.firstName} ${widget.tenant.lastName}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Room: ${widget.tenant.roomName}'),
                      Row(
                        children: [
                          Text('Phone: '),
                          GestureDetector(
                              onTap: () {
                                Uri url = Uri.parse(
                                    "tel://${widget.tenant.phoneNumber}");
                                launchUrl(url);
                              },
                              child: Text(
                                widget.tenant.phoneNumber,
                                style: TextStyle(
                                    color: Colors.lightBlue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.lightBlue),
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              FlutterClipboard.copy(widget.tenant.phoneNumber)
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
                                Uri url =
                                    Uri.parse("mailto:${widget.tenant.email}");
                                launchUrl(url);
                              },
                              child: Text(
                                widget.tenant.email,
                                style: TextStyle(
                                    color: Colors.lightBlue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.lightBlue),
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              FlutterClipboard.copy(widget.tenant.email)
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
                      Text(
                          'Last Payment Date: ${_formattedDate(widget.tenant.lastPaymentDate)}'),
                      Text(
                          'Next Payment Date: ${_formattedDate(widget.tenant.lastPaymentDate.add(Duration(days: 30)))}'),
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
                      SizedBox(height: 8),
                      Text(
                        '*You can only set monthly rent every 15 days.',
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _titleController,
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
                      TextButton(
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            // _dueDateController.text =
                            //     "${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.year.toString()}";
                            setState(() {
                              selectedStartDate = pickedDate;
                              picked_date = pickedDate;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 8),
                            Text(
                              'Due Date: ${_formattedDate(selectedStartDate)}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      // TextField(
                      //   controller: _dueDateController,
                      //   decoration: InputDecoration(
                      //     labelText: 'Due Date',
                      //     border: OutlineInputBorder(),
                      //     suffixIcon: IconButton(
                      //       onPressed: () async {
                      //         final DateTime? pickedDate = await showDatePicker(
                      //           context: context,
                      //           initialDate: DateTime.now(),
                      //           firstDate: DateTime(2000),
                      //           lastDate: DateTime(2101),
                      //         );
                      //         if (pickedDate != null) {
                      //           _dueDateController.text =
                      //               "${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.year.toString()}";
                      //           picked_date = pickedDate;
                      //         }
                      //       },
                      //       icon: Icon(Icons.calendar_today),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 16),
                      Text(
                        'Rent: ₱${widget.tenant.rentPrice}',
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
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
                        controller: _electricityController,
                        onChanged: (value) {
                          updateTotal();
                        },
                        decoration: InputDecoration(
                          labelText: 'Electricity (Optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _waterController,
                        onChanged: (value) {
                          updateTotal();
                        },
                        decoration: InputDecoration(
                          labelText: 'Water (Optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Total: $_total',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton(
                            // Set to inSeconds for testing purposes
                            // You can set it to inDays to check difference in days
                            onPressed: DateTime.now()
                                        .difference(
                                            widget.tenant.lastPaymentDate)
                                        .inSeconds <= 15
                                ? null
                                : () async {
                                    // Logic to set monthly rent
                                    if (_titleController.text.isEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  'Please input all required fields to proceed.',
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
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                      );
                                      try {
                                        await _makePayment(PaymentModel(
                                            propertyID:
                                                widget.tenant.propertyID,
                                            tenantID: widget.tenant.userID,
                                            lessorID:
                                                widget.tenant.propertyOwner,
                                            dueDate: picked_date,
                                            status: 'pending',
                                            paymentDate: DateTime.now(),
                                            title: _titleController.text.trim(),
                                            amount: _total));
                                        await _makeNotificationForTenant(
                                            widget.tenant.userID,
                                            _titleController.text.trim());
                                      } on Exception catch (e) {
                                        debugPrint(e.toString());
                                      }
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(
                                        msg: "Monthly rent set!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                      UserModel userModel =
                                          (await UserModel.getUserData(
                                              user.uid))!;
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LessorHomeUI(
                                                      user: userModel)));
                                    }
                                  },
                            child: Text('Set Monthly Rent'),
                          ),
                        ],
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

  void updateTotal() {
    setState(() {
      _total = widget.tenant.rentPrice +
          (_electricityController.text.isEmpty
              ? 0
              : double.parse(_electricityController.text)) +
          (_waterController.text.isEmpty
              ? 0
              : double.parse(_waterController.text));
    });
  }

  Future<void> _makePayment(PaymentModel paymentModel) async {
    await _paymentController.addPayment(paymentModel: paymentModel);
  }

  Future<void> _makeNotificationForTenant(String tenantID, String title) async {
    CollectionReference notifications =
        FirebaseFirestore.instance.collection('notifications');

    await notifications.add({
      'userID': tenantID,
      'message': 'You have a new pending payment: $title',
      'notificationID': '',
      'notificationDate': DateTime.now()
    }).then((newNotification) async {
      await newNotification.update({'notificationID': newNotification.id});
    });
  }

  String _formattedDate(DateTime date) {
    return '${date.month}-${date.day}-${date.year}';
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
