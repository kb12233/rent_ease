import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_ease/models/payment_model.dart';
import 'package:rent_ease/models/property_model.dart';

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
        photoURLs: propertyQuery.docs[0]['photoURLs'],
        minStay: propertyQuery.docs[0]['minStay'],
      );
    } else {
      propertyModel = null;
    }

    await payments.add({
      'propertyID': paymentModel.propertyID,
      'tenantID': paymentModel.tenantID,
      'lessorID': paymentModel.lessorID,
      'dueDate': paymentModel.dueDate,
      'paymentDate': paymentModel.paymentDate,
      'status': paymentModel.status,
      'amount': propertyModel?.rentPrice,
    });
  }
}
