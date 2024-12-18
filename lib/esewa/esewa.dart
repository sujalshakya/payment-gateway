import 'package:flutter/material.dart';
import 'package:payment_gateway_package/esewa/esewa_viewmodel.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment_success_response.dart';

class Esewa extends StatelessWidget {
  /// Whether it is for testing or not, true on default.
  final bool testmode;

  /// Details about the product such as product id, price, name and callback url.
  /// Esewa sends a proof of payment in the callback-URL after successful payment in live environment.
  final EsewaPayment esewaPayment;

  /// Id of client, used for credentials.
  final String clientId;

  /// Secret Id, used for credentials.
  final String secretId;

  /// Height of logo.

  final double? height;

  /// Width of logo.
  final double? width;
  final Function(EsewaPaymentSuccessResponse) onSuccess;
  final Function(String) onCancellation;

  final Function(String) onFailure;

  const Esewa(
      {super.key,
      this.testmode = true,
      required this.clientId,
      this.height,
      this.width,
      required this.secretId,
      required this.esewaPayment,
      required this.onFailure,
      required this.onCancellation,
      required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    final viewModel = EsewaViewmodel();
    return GestureDetector(
        onTap: () async {
          viewModel.testmode = testmode;
          await viewModel
              .initializeEsewa(clientId, secretId, esewaPayment)
              .then((result) {
            if (result.isSuccess) {
              onSuccess(result.data!);
            } else if (result.isFailed) {
              onFailure(result.message!);
            } else if (result.isCancelled) {
              onCancellation(result.message!);
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
