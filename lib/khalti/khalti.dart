import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'package:payment_gateway_package/khalti/khalti_failure_model.dart';

class KhaltiSDKDemo extends StatefulWidget {
  /// Payment Identifier for Khalti.
  final String pidx;

  /// Width of logo.

  final double? width;

  /// Height of logo.

  final double? height;

  /// Whether it is for testing or not, true on default.

  final bool testMode;

  /// Public key for Khalti API.
  final String publicKey;

  /// function to trigger on success of payment.

  final Function(PaymentResult?) onSuccess;

  /// function to trigger on failure of payment.

  final Function(KhaltiFailureModel) onFailure;

  /// Khalti payment integration widget.
  const KhaltiSDKDemo(
      {super.key,
      required this.publicKey,
      required this.pidx,
      this.testMode = true,
      this.height,
      this.width,
      required this.onSuccess,
      required this.onFailure});
  @override
  State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
  late final Future<Khalti?> khalti;
  late final String? pidx;

  PaymentResult? paymentResult;

  @override
  void initState() {
    super.initState();

    final payConfig = KhaltiPayConfig(
      publicKey: 'widget.publicKey',
      pidx: widget.pidx,
      environment: widget.testMode ? Environment.test : Environment.prod,
    );

    khalti = Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,
      onPaymentResult: (paymentResult, khalti) {
        log(paymentResult.toString());
        setState(() {
          this.paymentResult = paymentResult;
        });
        widget.onSuccess(paymentResult);
        khalti.close(context);
      },
      onMessage: (
        khalti, {
        description,
        statusCode,
        event,
        needsPaymentConfirmation,
      }) async {
        log(
          'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
        );
        widget.onFailure(KhaltiFailureModel(
            description: description,
            statusCode: statusCode,
            event: event,
            needsPaymentConfirmation: needsPaymentConfirmation));

        khalti.close(context);
      },
      onReturn: () => log('Successfully redirected to return_url.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: khalti,
        initialData: null,
        builder: (context, snapshot) {
          final khaltiSnapshot = snapshot.data;
          if (khaltiSnapshot == null) {
            return const CircularProgressIndicator.adaptive();
          }
          return GestureDetector(
              onTap: () {
                khaltiSnapshot.open(context);
              },
              child: Image.asset("assets/images/khalti.png",
                  width: widget.width ?? 40,
                  height: widget.height ?? 40,
                  package: 'payment_gateway_package'));
        },
      ),
    );
  }
}
