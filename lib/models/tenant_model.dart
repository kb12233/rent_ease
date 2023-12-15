// models/tenant_model.dart


class TenantModel {
  final String userID;
  final String firstName;
  final String lastName;
  final String roomName;
  final String phoneNumber; // New property for phone number
  final String email; // New property for email

  TenantModel({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.roomName,
    required this.phoneNumber,
    required this.email,
  });
}
