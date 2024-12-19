import 'package:flutter/material.dart';
import 'package:payment_gateway_package/esewa/esewa.dart';
import 'package:payment_gateway_package/imepay/imepay.dart';
import 'package:payment_gateway_package/imepay/imepay_model.dart';
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
    final purchaseDetailModel = PurchaseDetailModel(
        returnUrl: 'https://www.google.com/',
        websiteUrl: 'https://www.google.com/',
        amount: 10000,
        purchaseOrderId: '1',
        purchaseOrderName: 'Test');
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          KhaltiWidget(
            publicKey: '70ac1e9ae2534d63bff4db0ab92257e2',
            onFailure: (p0) {
              debugPrint("onFailure ${p0.needsPaymentConfirmation}");
            },
            pidxRequest: purchaseDetailModel,
            onSuccess: (response) {
              debugPrint("onSuccess ${response!.payload!.status}");
            },
            secretKey: '6465d7e60f3549ad93a49e61949fd94a',
          ),
          Esewa(
            // Secret ID for eSewa.
            secretId: 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
            // Client ID for eSewa.
            clientId: 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
            // Defines eSewa product details.

            esewaPayment: purchaseDetailModel,

            /// function to trigger on success of payment.
            /// Provides EsewaPaymentSuccessResponse.

            onSuccess: (result) =>
                debugPrint("onsuccesss${result.merchantName}"),

            /// function to trigger on failure of payment.

            onFailure: (message) => debugPrint("onFailure $message"),

            /// function to trigger on cancellation of payment.

            onCancellation: (message) => debugPrint("onCancellation $message}"),
          ),
          Imepay(
            onSuccess: (object) => debugPrint("onCancellation $object}"),
            purchaseDetailModel: purchaseDetailModel,
            transaction: ImePayModel(
              merchantCode: 'merchantCode',
              merchantName: 'merchantName',
              module: 'module',
              user: 'user',
              password: 'password',
            ),
          )
        ],
      ),
    );
  }
}
