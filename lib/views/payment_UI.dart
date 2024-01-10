// // import 'package:flutter/material.dart';

// // class PaymentUI extends StatelessWidget {
// //   const PaymentUI({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Placeholder();
// //   }
// // }

// // payment_UI.dart

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:rent_ease/controllers/payment_controller.dart';

// class PaymentUI extends StatefulWidget {
//   const PaymentUI({super.key});

//   @override
//   _PaymentUIState createState() => _PaymentUIState();
// }

// class _PaymentUIState extends State<PaymentUI> {
//   late PaymentController _paymentController;
//   late Stream<QuerySnapshot> _paymentStream;
//   final String userID = FirebaseAuth.instance.currentUser!.uid;

//   @override
//   void initState() {
//     super.initState();
//     _paymentController = PaymentController();
//     _paymentStream = _paymentController.getPendingPayments(userID: userID);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pending Payments'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _paymentStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No pending payments.'));
//           } else {
//             var payments = snapshot.data!.docs;

//             return ListView.builder(
//               itemCount: payments.length,
//               itemBuilder: (context, index) {
//                 var payment = payments[index].data() as Map<String, dynamic>;

//                 return ListTile(
//                   title: Text('Amount: ${payment['amount']}'),
//                   subtitle: Text('Due Date: ${payment['dueDate'].toDate()}'),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextButton(
//                         onPressed: () {
//                           // Add logic to handle payment
//                           // For example: _handlePayment(payment);
//                         },
//                         child: Text('Pay'),
//                       ),
//                       SizedBox(width: 8),
//                       TextButton(
//                         onPressed: () {
//                           // Add logic to handle cancel
//                           // For example: _handleCancel(payment);
//                         },
//                         child: Text('Cancel'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// payment_UI.dart



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:rent_ease/controllers/payment_controller.dart';

// class PaymentUI extends StatefulWidget {
//   const PaymentUI({super.key});

//   @override
//   _PaymentUIState createState() => _PaymentUIState();
// }

// class _PaymentUIState extends State<PaymentUI> {
//   late PaymentController _paymentController;
//   late Stream<QuerySnapshot> _paymentStream;
//   final String userID = FirebaseAuth.instance.currentUser!.uid;

//   @override
//   void initState() {
//     super.initState();
//     _paymentController = PaymentController();
//     _paymentStream = _paymentController.getPendingPayments(userID: userID);
//   }

//    @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Pending Payments'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _paymentStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No pending payments.'));
//           } else {
//             var payments = snapshot.data!.docs;

//             return ListView.builder(
//               itemCount: payments.length,
//               itemBuilder: (context, index) {
//                 var payment = payments[index].data() as Map<String, dynamic>;

//                 return Card(
//                   elevation: 5,
//                   margin: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ListTile(
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//                     title: Text(
//                       'Amount: ₱${payment['amount']}',
//                       style: TextStyle(
//                         // fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 8),
//                         Text(
//                           'Due Date: ${_formatDate(payment['dueDate'].toDate())}',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 16,
//                           ),
//                         ),
//                         SizedBox(height: 12),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             ButtonTheme(
//                               minWidth: 150,  // Set the desired width for the buttons
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   // Add logic to handle payment
//                                 },
//                                 child: Text('Pay with Google Pay'),
//                                 style: ElevatedButton.styleFrom(
//                                   primary: Colors.green,
//                                   onPrimary: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 16),
//                             ButtonTheme(
//                               minWidth: 150,  // Set the same width for the cancel button
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   // Add logic to handle cancel
//                                 },
//                                 child: Text('Cancel'),
//                                 style: ElevatedButton.styleFrom(
//                                   primary: Colors.red,
//                                   onPrimary: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   // Function to format the date
//   String _formatDate(DateTime date) {
//     return '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}-${date.year.toString()}';
//   }
// }

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
                        contentPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pay for Reservation fee',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Amount: ₱${payment['amount']}',
                              style: TextStyle(
                                fontSize: 18,
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
                                color: Colors.grey[600],
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
                                    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
                                    paymentItems: [],
                                    onPaymentResult: onGooglePayResult,
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
                            await _paymentController.cancelPayment(payments[index].id);
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
    debugPrint(paymentResult.toString() + '1990');
  }
}
