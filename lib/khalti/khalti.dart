import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'package:payment_gateway_package/khalti/helper.dart';
import 'package:payment_gateway_package/khalti/khalti_failure_model.dart';
import 'package:payment_gateway_package/transaction_detail_model.dart';

class KhaltiWidget extends StatefulWidget {
  /// Width of the logo for Khalti payment widget.
  final double? width;

  /// Height of the logo for Khalti payment widget.
  final double? height;

  /// Whether it is for testing or production mode. Default is true for test mode.
  final bool testMode;

  /// Public key for Khalti API integration.
  final String publicKey;

  /// Secret key for Khalti API integration.
  final String secretKey;

  /// Data required to generate Khalti pidx (Payment ID).
  final TransactionDetails pidxRequest;

  /// Callback function to trigger on success of payment.
  final Function(PaymentResult?) onSuccess;

  /// Callback function to trigger on failure of payment.
  final Function(KhaltiFailureModel) onFailure;

  /// Khalti payment integration widget constructor.
  const KhaltiWidget({
    super.key,
    required this.publicKey,
    this.testMode = true,
    this.height,
    this.width,
    required this.secretKey,
    required this.pidxRequest,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  State<KhaltiWidget> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiWidget> {
  // Future to initialize the Khalti SDK.
  late Future<Khalti?> khalti = Future.value(null);

  // Payment result object.
  PaymentResult? paymentResult;

  // Payment ID (pidx) fetched from the API.
  String? pidx;

  @override
  void initState() {
    super.initState();
    // Initialize payment when the widget is loaded.
    _initializePayment();
  }

  // Function to initialize Khalti payment by fetching pidx and setting up KhaltiPayConfig.
  Future<void> _initializePayment() async {
    try {
      // Fetch pidx (Payment ID) from the API using the provided request data.
      final response = await generatePidx(
        widget.pidxRequest,
        widget.testMode,
        widget.secretKey,
      );

      // Check if pidx was successfully fetched.
      pidx = response?.pidx ?? "";
      if (pidx == null) {
        throw Exception("Failed to fetch pidx");
      }
      setState(() {});

      // Set up KhaltiPayConfig with public key, pidx, and environment.
      final payConfig = KhaltiPayConfig(
        publicKey: widget.publicKey,
        pidx: pidx!,
        environment: widget.testMode ? Environment.test : Environment.prod,
      );

      // Initialize Khalti SDK with the configuration.
      khalti = Khalti.init(
        enableDebugging: true, // Enable debugging logs.
        payConfig: payConfig, // Pass the payment configuration.
        onPaymentResult: (paymentResult, khalti) {
          log(paymentResult.toString()); // Log the payment result.
          setState(() {
            this.paymentResult = paymentResult;
          });
          widget.onSuccess(paymentResult); // Trigger on success callback.
          khalti.close(context); // Close the Khalti SDK screen.
        },
        onMessage: (
          khalti, {
          description,
          statusCode,
          event,
          needsPaymentConfirmation,
        }) async {
          // Log the message from Khalti SDK for debugging.
          log(
            'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
          );

          // Trigger on failure callback with failure details.
          widget.onFailure(
            KhaltiFailureModel(
              description: description,
              statusCode: statusCode,
              event: event,
              needsPaymentConfirmation: needsPaymentConfirmation,
            ),
          );

          khalti.close(context); // Close the Khalti SDK screen after failure.
        },
        onReturn: () => log('Successfully redirected to return_url.'),
      );
    } catch (e) {
      // Handle errors during initialization.
      log("Error initializing Khalti: $e");

      // Trigger on failure callback with error details.
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
        future: khalti, // Waiting for Khalti SDK to initialize.
        initialData: null,
        builder: (context, snapshot) {
          final khaltiSnapshot = snapshot.data;

          // Show a loading indicator while waiting for Khalti to initialize.
          if (khaltiSnapshot == null) {
            return const CircularProgressIndicator.adaptive();
          }

          // Display Khalti logo and allow user to tap to initiate the payment.
          return GestureDetector(
            onTap: () {
              khaltiSnapshot.open(context); // Open Khalti SDK for payment.
            },
            child: Image.asset(
              "assets/images/khalti.png",
              width: widget.width ?? 40,
              height: widget.height ?? 40,
              package: 'payment_gateway_package',
            ),
          );
        },
      ),
    );
  }
}
