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

/// Home widget containing the UI and functionality for the payment gateway example.
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    /// Defining the purchase details model used for all payment gateways.

    final purchaseDetailModel = PurchaseDetailModel(

        /// URL to return after payment.

        returnUrl: 'https:///www.google.com/',

        /// URL for the website.
        websiteUrl: 'https:///www.google.com/',

        /// Amount for the transaction.

        amount: 10000,

        /// Unique purchase order ID.

        purchaseOrderId: '1',

        /// Name of the order.

        purchaseOrderName: 'Test');

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Khalti payment gateway widget.
          KhaltiWidget(
            /// Public key for Khalti API.

            publicKey: '70ac1e9ae2534d63bff4db0ab92257e2',

            /// Handle failure.

            onFailure: (p0) {
              debugPrint("onFailure ${p0.needsPaymentConfirmation}");
            },

            /// Passing the purchase details.

            pidxRequest: purchaseDetailModel,

            /// Handle success.

            onSuccess: (response) {
              debugPrint("onSuccess ${response!.payload!.status}");
            },

            /// Secret key for Khalti API.

            secretKey: '6465d7e60f3549ad93a49e61949fd94a',
          ),

          /// eSewa payment gateway widget.
          Esewa(
            /// Secret ID for eSewa.

            secretId: 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',

            /// Client ID for eSewa.

            clientId: 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',

            /// Passing the purchase details.

            esewaPayment: purchaseDetailModel,

            //// Function triggered on successful payment.
            onSuccess: (result) =>
                debugPrint("onsuccesss${result.merchantName}"),

            //// Function triggered on failure of payment.
            onFailure: (message) => debugPrint("onFailure $message"),

            //// Function triggered on cancellation of payment.
            onCancellation: (message) => debugPrint("onCancellation $message}"),
          ),

          /// Imepay payment gateway widget.
          Imepay(
            /// Handle success.

            onSuccess: (object) => debugPrint("onCancellation $object}"),

            /// Passing the purchase details.

            purchaseDetailModel: purchaseDetailModel,

            transaction: ImePayModel(
              /// Merchant code for Imepay.

              merchantCode: 'merchantCode',

              /// Merchant name for Imepay.

              merchantName: 'merchantName',

              /// Module  for Imepay.

              module: 'module',

              /// User identifier for Imepay.

              user: 'user',

              /// Users Password for Imepay.

              password: 'password',
            ),
          )
        ],
      ),
    );
  }
}
