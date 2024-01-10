// reservation_requests_UI.dart

// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_ease/controllers/payment_controller.dart';
import 'package:rent_ease/models/payment_model.dart';

import 'package:rent_ease/models/reservation_model.dart';
import 'package:rent_ease/controllers/reservation_controller.dart';
import 'package:rent_ease/views/tenant_home_UI.dart';

class ReservationRequestsUI extends StatefulWidget {
  ReservationRequestsUI({super.key});

  @override
  _ReservationRequestsUIState createState() => _ReservationRequestsUIState();
}

class _ReservationRequestsUIState extends State<ReservationRequestsUI> {
  late Stream<QuerySnapshot> _reservationStream;
  late ReservationController _reservationController;
  late PaymentController _paymentController;
  final String lessorID = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _reservationController = ReservationController(lessorId: lessorID);
    _paymentController = PaymentController();
    _reservationStream = _reservationController.getReservationStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _reservationStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var reservations =
                _reservationController.mapReservations(snapshot.data!);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  var reservation = reservations[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Card(
                      elevation: 0,
                      color: Colors.grey[200],
                      child: ListTile(
                        title: Text(
                            '${reservation.firstName} ${reservation.lastName}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Property: ${reservation.propertyName}',
                            ),
                            Text(
                              'Start Date: ${_formatDate(reservation.startDate)}',
                            ),
                            Text(
                              'End Date: ${_formatDate(reservation.endDate)}',
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                _acceptReservation(reservation);
                                _makeReservationFeePayment(
                                  PaymentModel(
                                    title: 'Pay for Reservation fee',
                                    propertyID: reservation.propertyID,
                                    tenantID: reservation.userID,
                                    lessorID: lessorID,
                                    dueDate: DateTime.now().add(Duration(days: 7)), 
                                    paymentDate: DateTime.now(),
                                    status: 'pending',
                                  )
                                );
                              },
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            TextButton(
                              onPressed: () => _rejectReservation(reservation),
                              child: Text(
                                'Reject',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () => _navigateToReservationDetails(reservation),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Convert DateTime to string and extract the date part
    return '${date.month}-${date.day}-${date.year}';
  }

  void _navigateToReservationDetails(ReservationModel reservation) {
    // Implement navigation to reservation details page if needed
    // For example:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ReservationDetailsUI(reservation: reservation),
    //   ),
    // );
  }

  void _acceptReservation(ReservationModel reservation) async {
    await _reservationController.acceptReservation(reservation);
    // You may want to update the UI or show a confirmation message here
  }

  void _makeReservationFeePayment(PaymentModel paymentModel) async {
    await _paymentController.addPayment(paymentModel: paymentModel);
  }

  void _rejectReservation(ReservationModel reservation) async {
    await _reservationController.rejectReservation(reservation);
    // You may want to update the UI or show a confirmation message here
  }
}
