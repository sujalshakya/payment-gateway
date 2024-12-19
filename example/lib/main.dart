import 'package:flutter/material.dart';
import 'package:payment_gateway_package/esewa/esewa.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment.dart';
import 'package:payment_gateway_package/khalti/khalti.dart';
import 'package:payment_gateway_package/khalti/khalti_pidx_request.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

// Home widget containing the UI and functionality for the payment gateway demo.
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          KhaltiSDKDemo(
            pidx: 'HGikCgwE8WL9qQKSXR3WbC',
            publicKey: '70ac1e9ae2534d63bff4db0ab92257e2',
            onSuccess: (p0) {
              debugPrint("onSuccess ${p0?.payload?.status}");
            },
            onFailure: (p0) {
              debugPrint("onFailure ${p0.needsPaymentConfirmation}");
            },
            pidxRequest: KhaltiPidxRequest(
                returnUrl: 'https://www.google.com/',
                websiteUrl: 'https://www.google.com/',
                amount: 10000,
                purchaseOrderId: '1',
                purchaseOrderName: 'Test'),
          ),
          Esewa(
            // Secret ID for eSewa.
            secretId: 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
            // Client ID for eSewa.
            clientId: 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
            // Defines eSewa product details.

            esewaPayment: EsewaPayment(
              // ID of the product being purchased.
              productId: '1',
              // Name of the product.
              productName: 'String',
              // Price of the product.
              productPrice: '1000',
              // Callback URL after payment.
              callbackUrl: 'www.google.com',
            ),

            /// function to trigger on success of payment.
            /// Provides EsewaPaymentSuccessResponse.

            onSuccess: (result) =>
                debugPrint("onsuccesss${result.merchantName}"),

            /// function to trigger on failure of payment.

            onFailure: (message) => debugPrint("onFailure $message"),

            /// function to trigger on cancellation of payment.

            onCancellation: (message) => debugPrint("onCancellation $message}"),
          ),
        ],
      ),
    );
  }
}
