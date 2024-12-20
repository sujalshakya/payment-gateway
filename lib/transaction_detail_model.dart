import 'package:payment_gateway_package/success_response.dart';

class TransactionDetails {
  final String returnUrl;
  final String websiteUrl;
  final int amount;
  final String id;
  final String orderName;
  final Function(SuccessResponse) onSuccess;
  final Function(String) onCancellation;
  final Function(String) onFailure;
  final String clientId;
  final String secretId;
  final String? imepayMerchantCode;
  final String? imepayMerchantName;
  final String? imepayModule;
  final String? imepayUser;
  final String? imepayPassword;

  TransactionDetails({
    required this.clientId,
    required this.secretId,
    required this.onSuccess,
    required this.onCancellation,
    required this.onFailure,
    required this.returnUrl,
    required this.websiteUrl,
    required this.amount,
    required this.id,
    required this.orderName,
    this.imepayMerchantCode,
    this.imepayMerchantName,
    this.imepayModule,
    this.imepayUser,
    this.imepayPassword,
  });

  TransactionDetails copyWith({
    String? returnUrl,
    String? websiteUrl,
    int? amount,
    String? id,
    String? orderName,
    Function(Object)? onSuccess,
    Function(String)? onCancellation,
    Function(String)? onFailure,
    String? clientId,
    String? secretId,
    String? imepayMerchantCode,
    String? imepayMerchantName,
    String? imepayModule,
    String? imepayUser,
    String? imepayPassword,
  }) {
    return TransactionDetails(
      returnUrl: returnUrl ?? this.returnUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      amount: amount ?? this.amount,
      id: id ?? this.id,
      orderName: orderName ?? this.orderName,
      onSuccess: onSuccess ?? this.onSuccess,
      onCancellation: onCancellation ?? this.onCancellation,
      onFailure: onFailure ?? this.onFailure,
      clientId: clientId ?? this.clientId,
      secretId: secretId ?? this.secretId,
      imepayMerchantCode: imepayMerchantCode ?? this.imepayMerchantCode,
      imepayMerchantName: imepayMerchantName ?? this.imepayMerchantName,
      imepayModule: imepayModule ?? this.imepayModule,
      imepayUser: imepayUser ?? this.imepayUser,
      imepayPassword: imepayPassword ?? this.imepayPassword,
    );
  }
}
