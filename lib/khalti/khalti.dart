import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'package:payment_gateway_package/khalti/helper.dart';
import 'package:payment_gateway_package/khalti/khalti_failure_model.dart';
import 'package:payment_gateway_package/khalti/khalti_pidx_request.dart';

class KhaltiWidget extends StatefulWidget {
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

  final KhaltiPidxRequest pidxRequest;

  /// function to trigger on success of payment.

  final Function(PaymentResult?) onSuccess;

  /// function to trigger on failure of payment.

  final Function(KhaltiFailureModel) onFailure;

  /// Khalti payment integration widget.
  const KhaltiWidget(
      {super.key,
      required this.publicKey,
      required this.pidx,
      this.testMode = true,
      this.height,
      this.width,
      required this.pidxRequest,
      required this.onSuccess,
      required this.onFailure});
  @override
  State<KhaltiWidget> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiWidget> {
  late Future<Khalti?> khalti = Future.value(null);
  PaymentResult? paymentResult;
  String? pidx;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    try {
      // Fetch pidx from the API
      final response = await generatePidx(widget.pidxRequest, widget.testMode);
      pidx = response?.pidx ?? "";
      if (pidx == null) {
        throw Exception("Failed to fetch pidx");
      }
      setState(() {});
      final payConfig = KhaltiPayConfig(
        publicKey: widget.publicKey,
        pidx: pidx!,
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
          widget.onFailure(
            KhaltiFailureModel(
              description: description,
              statusCode: statusCode,
              event: event,
              needsPaymentConfirmation: needsPaymentConfirmation,
            ),
          );

          khalti.close(context);
        },
        onReturn: () => log('Successfully redirected to return_url.'),
      );
    } catch (e) {
      log("Error initializing Khalti: $e");
      widget.onFailure(KhaltiFailureModel(
        description: "Error initializing Khalti: $e",
        statusCode: null,
        event: null,
        needsPaymentConfirmation: null,
      ));
    }
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
