import 'package:flutter/material.dart';
import 'package:payment_gateway_package/esewa/esewa_viewmodel.dart';
import 'package:payment_gateway_package/success_response.dart';
import 'package:payment_gateway_package/transaction_detail_model.dart' as base;

class Esewa extends StatelessWidget {
  /// Whether it is for testing or not, true on default.
  final bool testmode;

  /// Details about the product such as product id, price, name and callback url.
  /// Esewa sends a proof of payment in the callback-URL after successful payment in live environment.
  final base.TransactionDetails esewaPayment;

  /// Height of logo.

  final double? height;

  /// Width of logo.
  final double? width;

  /// eSewa payment integration widget.

  const Esewa({
    super.key,
    this.testmode = true,
    this.height,
    this.width,
    required this.esewaPayment,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = EsewaViewmodel();
    return GestureDetector(
        onTap: () async {
          viewModel.testmode = testmode;
          await viewModel
              .initializeEsewa(
                  esewaPayment.clientId, esewaPayment.secretId, esewaPayment)
              .then((result) {
            if (result.isSuccess) {
              esewaPayment.onSuccess(SuccessResponse(
                  orderId: result.data?.productId ?? "",
                  orderName: result.data?.productName ?? "",
                  totalAmount: result.data?.totalAmount.toString() ?? "",
                  status: result.data?.transactionDetails?.status ?? "",
                  time: result.data?.transactionDetails?.date ?? ""));
            } else if (result.isFailed) {
              esewaPayment.onFailure(result.message!);
            } else if (result.isCancelled) {
              esewaPayment.onCancellation(result.message!);
            }
          });
        },
        child: Image.asset(
          'assets/images/esewa.png',
          package: 'payment_gateway_package',
          height: height ?? 40,
          width: width ?? 40,
        ));
  }
}
