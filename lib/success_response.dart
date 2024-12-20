class SuccessResponse {
  final String orderId;
  final String orderName;
  final String totalAmount;
  final String status;
  final String time;

  SuccessResponse({
    required this.orderId,
    required this.orderName,
    required this.totalAmount,
    required this.status,
    required this.time,
  });
}
