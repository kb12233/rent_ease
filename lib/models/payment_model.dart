class PaymentModel {
  final String propertyID;
  final String tenantID;
  final String lessorID;
  final double amount;
  final DateTime dueDate;
  final DateTime paymentDate;
  final String status;

  PaymentModel({
    required this.propertyID,
    required this.tenantID,
    required this.lessorID,
    required this.dueDate,
    required this.status,
    required this.paymentDate,
    this.amount = 0,
  });
}
