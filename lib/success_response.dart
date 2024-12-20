class SuccessResponse {
  final String transactionId;
  final String orderName;
  final String totalAmount;
  final String status;
  final String time;

  SuccessResponse({
    required this.transactionId,
    required this.orderName,
    required this.totalAmount,
    required this.status,
    required this.time,
  });
}
