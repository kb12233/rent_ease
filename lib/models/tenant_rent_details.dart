// models/tenant_model.dart

import 'dart:ffi';

class TenantRentDetails {
  final String userID;
  final String firstName;
  final String lastName;
  final String roomName;
  final String phoneNumber; // New property for phone number
  final String email; // New property for email
  final double rentPrice;
  final String propertyID;
  final String propertyOwner;

  TenantRentDetails(
      {required this.userID,
      required this.firstName,
      required this.lastName,
      required this.roomName,
      required this.phoneNumber,
      required this.email,
      required this.rentPrice,
      required this.propertyID,
      required this.propertyOwner});
}
