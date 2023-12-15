// controllers/reservation_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_ease/models/reservation_model.dart';
import 'package:rent_ease/models/notification_model.dart';

class ReservationController {
  final String lessorId;

  ReservationController({required this.lessorId});

  Stream<QuerySnapshot> getReservationStream() {
    return FirebaseFirestore.instance
        .collection('reservations')
        .where('propertyOwner', isEqualTo: lessorId)
        .snapshots();
  }

  List<ReservationModel> mapReservations(QuerySnapshot snapshot) {
    return snapshot.docs
        .where((doc) => (doc.data() as Map<String, dynamic>)['is_accepted'] == false)
        .map((doc) {
      var data = doc.data() as Map<String, dynamic>;

      // Check if start_date is not null
      DateTime startDate = data['start_date'] != null
          ? (data['start_date'] as Timestamp).toDate()
          : DateTime.now();

      DateTime endDate = data['end_date'] != null
          ? (data['end_date'] as Timestamp).toDate()
          : startDate.add(Duration(days: 91)); // Default to 91 days from start date

      return ReservationModel(
        reservationID: doc.id,
        userID: data['userID'],
        firstName: data['firstname'],
        lastName: data['lastname'],
        propertyID: data['propertyID'],
        propertyName: data['propertyName'],
        propertyOwner: data['propertyOwner'],
        startDate: startDate,
        endDate: endDate,
        isAccepted: data['is_accepted'],
      );
    }).toList();
  }


  Future<void> acceptReservation(ReservationModel reservation) async {
    // Update the reservation in the 'reservations' collection
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservation.reservationID)
        .update({'is_accepted': true});

    // Update the corresponding property with the tenant information
    await FirebaseFirestore.instance
        .collection('properties')
        .doc(reservation.propertyID)
        .update({'tenant': reservation.userID});

    // Add a notification for the tenant
    await addNotification(NotificationModel(
      userID: reservation.userID,
      message: 'Your reservation request has been accepted!',
      notificationID: '',
    ));
  }

  Future<void> rejectReservation(ReservationModel reservation) async {
    // Delete the reservation record
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservation.reservationID)
        .delete();

    // Add a notification for the tenant
    await addNotification(NotificationModel(
      userID: reservation.userID,
      message: 'Your reservation request has been rejected :(',
      notificationID: '',
    ));
  }

  Future<void> submitReservationRequest({
    required String userID,
    required String firstName,
    required String lastName,
    required String propertyID,
    required String propertyName,
    required String propertyOwner,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('reservations').add({
        'userID': userID,
        'firstname': firstName,
        'lastname': lastName,
        'propertyID': propertyID,
        'propertyName': propertyName,
        'propertyOwner': propertyOwner,
        'start_date': startDate,
        'end_date': endDate,
        'is_accepted': false,
      });

      await addNotification(NotificationModel(
        userID: propertyOwner,
        message: 'You have a new Reservation Request from $firstName $lastName :)',
        notificationID: '',
      ));
    } catch (e) {
      print('Error submitting reservation request: $e');
      // You can handle the error as needed
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    CollectionReference notifications =
          FirebaseFirestore.instance.collection('notifications');

    await notifications.add({
      'userID': notification.userID,
      'message': notification.message,
      'notificationID': notification.notificationID,
    }).then((newNotification) async {
      await newNotification.update({'notificationID': newNotification.id});
    });
  }
}
