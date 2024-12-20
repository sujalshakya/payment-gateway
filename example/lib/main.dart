import 'package:flutter/material.dart';
import 'package:payment_gateway_package/esewa/esewa.dart';
import 'package:payment_gateway_package/imepay/imepay.dart';
import 'package:payment_gateway_package/imepay/imepay_model.dart';
import 'package:payment_gateway_package/khalti/khalti.dart';
import 'package:payment_gateway_package/transaction_detail_model.dart';

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

    final transactionDetails = TransactionDetails(

        /// URL to return after payment. Details of the transaction is sent to this url.

        returnUrl: 'https://www.google.com/',

        /// URL for the website.
        websiteUrl: 'https://www.google.com/',

        /// Amount for the transaction.

        amount: 1000,

        /// Unique purchase order ID.

        id: '1',

        /// Name of the order.

        orderName: 'Test');

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

            /// Passing the purchase details to generate pidx.

            pidxRequest: transactionDetails,

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

            esewaPayment: transactionDetails,

            //// Function triggered on successful payment.
            onSuccess: (result) =>
                debugPrint("onsuccesss${result.merchantName}"),

            //// Function triggered on failure of payment.
            onFailure: (message) => debugPrint("onFailure $message"),

            //// Function triggered on cancellation of payment.
            onCancellation: (message) => debugPrint("onCancellation $message"),
          ),

          /// Imepay payment gateway widget.
          Imepay(
            /// Handle success.

            onSuccess: (object) => debugPrint("onCancellation $object"),

            /// Passing the purchase details.

            transactionDetails: transactionDetails,

            transaction: ImePayModel(
              /// Merchant code for Imepay.

              merchantCode: 'EDUSANJAL',

              /// Merchant name for Imepay.

              merchantName: 'Edu Sanjal',

              /// Module  for Imepay.

              module: 'EDUSANJAL',

              /// User identifier for Imepay.

              user: 'edusanjal',

              /// Users Password for Imepay.

              password: 'ime@1234',
            ),
          )
        ],
      ),
    );
  }
}
