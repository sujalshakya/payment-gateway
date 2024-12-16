class EsewaPaymentSuccessResponse {
  final String? productId;
  final String? productName;
  final double? totalAmount;
  final String? code;
  final Message? message;
  final TransactionDetails? transactionDetails;
  final String? merchantName;

  EsewaPaymentSuccessResponse({
    this.productId,
    this.productName,
    this.totalAmount,
    this.code,
    this.message,
    this.transactionDetails,
    this.merchantName,
  });

  factory EsewaPaymentSuccessResponse.fromJson(Map<String, dynamic> json) {
    return EsewaPaymentSuccessResponse(
      productId: json['productId'],
      productName: json['productName'],
      totalAmount: json['totalAmount'] != null
          ? double.tryParse(json['totalAmount'])
          : null,
      code: json['code'],
      message:
          json['message'] != null ? Message.fromJson(json['message']) : null,
      transactionDetails: json['transactionDetails'] != null
          ? TransactionDetails.fromJson(json['transactionDetails'])
          : null,
      merchantName: json['merchantName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'totalAmount': totalAmount?.toString(),
      'code': code,
      'message': message?.toJson(),
      'transactionDetails': transactionDetails?.toJson(),
      'merchantName': merchantName,
    };
  }

  @override
  String toString() {
    return 'EsewaPaymentSuccessResponse(productId: $productId, productName: $productName, totalAmount: $totalAmount, code: $code, message: $message, transactionDetails: $transactionDetails, merchantName: $merchantName)';
  }
}

class Message {
  final String? technicalSuccessMessage;
  final String? successMessage;

  Message({
    this.technicalSuccessMessage,
    this.successMessage,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      technicalSuccessMessage: json['technicalSuccessMessage'],
      successMessage: json['successMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'technicalSuccessMessage': technicalSuccessMessage,
      'successMessage': successMessage,
    };
  }

  @override
  String toString() {
    return 'Message(technicalSuccessMessage: $technicalSuccessMessage, successMessage: $successMessage)';
  }
}

class TransactionDetails {
  final String? date;
  final String? referenceId;
  final String? status;

  TransactionDetails({
    this.date,
    this.referenceId,
    this.status,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) {
    return TransactionDetails(
      date: json['date'],
      referenceId: json['referenceId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'referenceId': referenceId,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'TransactionDetails(date: $date, referenceId: $referenceId, status: $status)';
  }
}
