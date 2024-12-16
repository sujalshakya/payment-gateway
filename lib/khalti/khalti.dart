import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';

class KhaltiSDKDemo extends StatefulWidget {
  final String pidx;
  final double? width;
  final double? height;
  final bool testMode;
  final String publicKey;
  const KhaltiSDKDemo({
    super.key,
    required this.publicKey,
    required this.pidx,
    this.testMode = true,
    this.height,
    this.width,
  });
  @override
  State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
  late final Future<Khalti?> khalti;

  PaymentResult? paymentResult;

  @override
  void initState() {
    super.initState();
    final payConfig = KhaltiPayConfig(
      publicKey: widget.publicKey,
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
              onTap: () => khaltiSnapshot.open(context),
              child: Image.asset("assets/images/khalti.png",
                  width: widget.width ?? 40,
                  height: widget.height ?? 40,
                  package: 'payment_gateway_package'));
        },
      ),
    );
  }
}
