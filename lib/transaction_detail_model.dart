class TransactionDetails {
  final String returnUrl;
  final String websiteUrl;
  final int amount;
  final String id;
  final String orderName;

  TransactionDetails({
    required this.returnUrl,
    required this.websiteUrl,
    required this.amount,
    required this.id,
    required this.orderName,
  });

  Map<String, dynamic> toJson() {
    return {
      "return_url": returnUrl,
      "website_url": websiteUrl,
      "amount": amount,
      "purchase_order_id": id,
      "purchase_order_name": orderName,
    };
  }
}
