import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:rent_ease/controllers/payment_controller.dart';
import 'package:rent_ease/payment_configurations.dart';

class PaymentUI extends StatefulWidget {
  const PaymentUI({super.key});

  @override
  _PaymentUIState createState() => _PaymentUIState();
}

class _PaymentUIState extends State<PaymentUI> {
  late PaymentController _paymentController;
  late Stream<QuerySnapshot> _paymentStream;
  final String userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _paymentController = PaymentController();
    _paymentStream = _paymentController.getPendingPayments(userID: userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text('Pending Payments'),
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _paymentStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No pending payments.'));
          } else {
            var payments = snapshot.data!.docs;

            return ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                var payment = payments[index].data() as Map<String, dynamic>;

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${payment['title']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Amount: ₱${payment['amount']}',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              'Due Date: ${_formatDate(payment['dueDate'].toDate())}',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonTheme(
                                  minWidth: 150,
                                  child: GooglePayButton(
                                    paymentConfiguration:
                                        PaymentConfiguration.fromJsonString(
                                            defaultGooglePay),
                                    paymentItems: [],
                                    onPaymentResult: (result) {
                                      // Add your code here to handle the payment result
                                      onGooglePayResult(result);
                                      _paymentController
                                          .updateStatusPaid(payments[index].id, payment['propertyID'], payment['tenantID'], payment['lessorID']);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  'Payment Successful',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                ElevatedButton(
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
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () async {
                            await _paymentController
                                .cancelPayment(payments[index].id);
                            setState(() {
                              // Optionally, you can add code here to refresh or update the UI
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to format the date
  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}-${date.year.toString()}';
  }

  void onGooglePayResult(dynamic paymentResult) {
    debugPrint(paymentResult.toString());
  }
}
