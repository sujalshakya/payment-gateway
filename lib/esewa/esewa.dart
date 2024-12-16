import 'package:flutter/material.dart';
import 'package:payment_gateway_package/esewa/esewa_viewmodel.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment.dart';

class EsewaView extends StatelessWidget {
  final bool testmode;
  final EsewaPayment esewaPayment;
  final String clientId;
  final String secretId;

  const EsewaView(
      {super.key,
      this.testmode = true,
      required this.clientId,
      required this.secretId,
      required this.esewaPayment});

  @override
  Widget build(BuildContext context) {
    final viewModel = EsewaViewmodel();
    return GestureDetector(
        onTap: () {
          viewModel.testmode = testmode;
          viewModel.esewa(clientId, secretId, esewaPayment);
        },
        child: Image.asset(
          'assets/images/esewa.png',
          package: 'payment_gateway_package',
          height: 40,
          width: 40,
        ));
  }
}
