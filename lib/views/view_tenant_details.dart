// view_tenant_details.dart

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_ease/controllers/payment_controller.dart';
import 'package:rent_ease/models/payment_model.dart';
import 'package:rent_ease/models/tenant_rent_details.dart';
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewTenantDetailsPage extends StatefulWidget {
  final TenantRentDetails tenant;

  ViewTenantDetailsPage({required this.tenant});

  @override
  _ViewTenantDetailsPageState createState() => _ViewTenantDetailsPageState();
}

class _ViewTenantDetailsPageState extends State<ViewTenantDetailsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _electricityController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();

  late PaymentController _paymentController;

  double _total = 0.0;
  late DateTime picked_date;

  @override
  void initState() {
    _total = widget.tenant.rentPrice;
    picked_date = DateTime.now();
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
                      '${widget.tenant.firstName} ${widget.tenant.lastName}'),
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
                                _dueDateController.text =
                                    "${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.year.toString()}";
                                picked_date = pickedDate;
                              }
                            },
                            icon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
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
                            onPressed: () {
                              // Logic to set monthly rent
                              _makePayment(PaymentModel(
                                propertyID: widget.tenant.propertyID, 
                                tenantID: widget.tenant.userID, 
                                lessorID: widget.tenant.propertyOwner, 
                                dueDate: picked_date, 
                                status: 'pending', 
                                paymentDate: DateTime.now(), 
                                title: _titleController.text.trim(),
                                amount: _total
                              ));
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

  void _makePayment(PaymentModel paymentModel) async {
    await _paymentController.addPayment(paymentModel: paymentModel);
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
