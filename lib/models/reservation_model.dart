// models/reservation_model.dart

class ReservationModel {
  final String reservationID;
  final String userID;
  final String firstName;
  final String lastName;
  final String propertyID;
  final String propertyName;
  final String propertyOwner;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAccepted;

  ReservationModel({
    required this.reservationID,
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.propertyID,
    required this.propertyName,
    required this.propertyOwner,
    required this.startDate,
    required this.endDate,
    required this.isAccepted,
  });
}
