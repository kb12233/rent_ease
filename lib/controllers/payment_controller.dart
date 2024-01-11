import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_ease/models/payment_model.dart';
import 'package:rent_ease/models/property_model.dart';
import 'package:rent_ease/models/user_model.dart';

class PaymentController {
  /*
  tenantID: reservation.userID, 
  lessorID: lessorID,
  dueDate: DateTime.now().add(Duration(days: 7)),
  paymentDate: DateTime.now(),
  status: 'pending'
  */
  Future<void> addPayment({required PaymentModel paymentModel}) async {
    CollectionReference payments =
        FirebaseFirestore.instance.collection('payments');

    CollectionReference properties =
        FirebaseFirestore.instance.collection('properties');

    QuerySnapshot propertyQuery = await properties
        .where('propertyID', isEqualTo: paymentModel.propertyID)
        .get();

    PropertyModel? propertyModel;
    List<String> photoURLs =
        List.from(propertyQuery.docs[0]['photoURLs'] ?? List.filled(8, ''));

    if (propertyQuery.size == 1) {
      // Map the fields to create a UserModel object
      propertyModel = PropertyModel(
        propertyID: propertyQuery.docs[0]['propertyID'],
        propertyOwner: propertyQuery.docs[0]['propertyOwner'],
        propertyName: propertyQuery.docs[0]['propertyName'],
        description: propertyQuery.docs[0]['description'],
        locationAddress: propertyQuery.docs[0]['locationAddress'],
        rentPrice: propertyQuery.docs[0]['rentPrice'],
        tenant: propertyQuery.docs[0]['tenant'],
        photoURLs: photoURLs,
        minStay: propertyQuery.docs[0]['minStay'],
      );
    } else {
      propertyModel = null;
    }

    await payments.add({
      'title': paymentModel.title,
      'propertyID': paymentModel.propertyID,
      'tenantID': paymentModel.tenantID,
      'lessorID': paymentModel.lessorID,
      'dueDate': paymentModel.dueDate,
      'paymentDate': paymentModel.paymentDate,
      'status': paymentModel.status,
      'amount': propertyModel?.rentPrice,
    });
  }

  
  Stream<QuerySnapshot<Object?>> getPendingPayments({required String userID}) {
    return FirebaseFirestore.instance
        .collection('payments')
        .where('tenantID', isEqualTo: userID)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  
  //new
  Future<void> cancelPayment(String paymentID) async {
    CollectionReference payments =
        FirebaseFirestore.instance.collection('payments');
    await payments.doc(paymentID).update({'status': 'cancelled'});
  }

  
  Future<void> updateStatusPaid(String paymentID, String propertyID,
      String tenantID, String lessorID) async {
    CollectionReference payments =
        FirebaseFirestore.instance.collection('payments');
    CollectionReference notifications =
        FirebaseFirestore.instance.collection('notifications');
    CollectionReference properties =
        FirebaseFirestore.instance.collection('properties');
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    QuerySnapshot propertyQuery =
        await properties.where('propertyID', isEqualTo: propertyID).get();

    QuerySnapshot userQuery =
        await users.where('userID', isEqualTo: tenantID).get();

    PropertyModel? propertyModel;
    UserModel? userModel;
    List<String> photoURLs =
        List.from(propertyQuery.docs[0]['photoURLs'] ?? List.filled(8, ''));

    if (propertyQuery.size == 1) {
      propertyModel = PropertyModel(
        propertyID: propertyQuery.docs[0]['propertyID'],
        propertyOwner: propertyQuery.docs[0]['propertyOwner'],
        propertyName: propertyQuery.docs[0]['propertyName'],
        description: propertyQuery.docs[0]['description'],
        locationAddress: propertyQuery.docs[0]['locationAddress'],
        rentPrice: propertyQuery.docs[0]['rentPrice'],
        tenant: propertyQuery.docs[0]['tenant'],
        photoURLs: photoURLs,
        minStay: propertyQuery.docs[0]['minStay'],
      );
    } else {
      propertyModel = null;
    }

    if (userQuery.size == 1) {
      userModel = UserModel(
          userID: userQuery.docs[0]['userID'],
          firstname: userQuery.docs[0]['firstname'],
          lastname: userQuery.docs[0]['lastname'],
          phoneNum: userQuery.docs[0]['phoneNum'],
          username: userQuery.docs[0]['username'],
          email: userQuery.docs[0]['email'],
          password: userQuery.docs[0]['password'],
          userType: userQuery.docs[0]['userType'],
          profilePictureURL: userQuery.docs[0]['profilePictureURL']);
    } else {
      userModel = null;
    }

    await payments.doc(paymentID).update({
      'status': 'paid',
      'paymentDate': DateTime.now()
    });

    await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyID)
        .update({'tenant': tenantID});

    await notifications.add({
      'userID': lessorID,
      'message':
          'You have received the Reservation fee for ${propertyModel?.propertyName} paid by ${userModel?.firstname} ${userModel?.lastname}',
      'notificationID': '',
      'notificationDate': DateTime.now()
    }).then((newNotification) async {
      await newNotification.update({'notificationID': newNotification.id});
    });
  }

  Future<DateTime> getLastPaymentDate(String propertyID, String tenantID) async {
    try {
      QuerySnapshot paymentQuery = await FirebaseFirestore.instance
          .collection('payments')
          .where('propertyID', isEqualTo: propertyID)
          .where('tenantID', isEqualTo: tenantID)
          .orderBy('paymentDate', descending: true)
          .limit(1)
          .get();

      if (paymentQuery.docs.isNotEmpty) {
        return paymentQuery.docs[0]['paymentDate'].toDate();
      }
    } catch (e) {
      debugPrint("Error getting last payment date: $e");
    }
    return DateTime(2000); // Return a default date if no payment found
  }
}
