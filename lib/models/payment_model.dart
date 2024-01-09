class PaymentModel {
  final String tenantID;
  final String lessorID;
  final double amount;
  final DateTime dueDate;
  final DateTime paymentDate;
  final String status;
  
  PaymentModel({
    required this.tenantID,
    required this.lessorID,
    required this.amount,
    required this.dueDate,
    required this.paymentDate,
    required this.status,
  });
}
