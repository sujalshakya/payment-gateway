import 'package:flutter/material.dart';
import 'package:payment_gateway_package/esewa/esewa.dart';
import 'package:payment_gateway_package/imepay/imepay.dart';
import 'package:payment_gateway_package/khalti/khalti.dart';
import 'package:payment_gateway_package/paypal/paypal.dart';
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

    TransactionDetails transactionDetails = TransactionDetails(
        clientId: 'clientId',
        secretId: 'secretId',
        onSuccess: (response) {
          debugPrint("onSuccess ${response.status}");
        },
        onFailure: (message) => debugPrint("onFailure $message"),
        onCancellation: (message) => debugPrint("onCancellation $message"),
        returnUrl: 'https://www.google.com/',
        websiteUrl: 'https://www.google.com/',
        amount: 1000,
        id: '1234',
        orderName: 'Test Order');

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Paypal(
            transactionDetails: transactionDetails.copyWith(
              websiteUrl: 'https://samplesite.com/cancel',
              returnUrl: 'https://samplesite.com/return',
              clientId:
                  'Af1N-W21JpPIuuQeQy01V4HN2IORfsigoiI-a1pVZU3dBocscrwYb3JbBNf6FZO_-xIlwvjTv-M-ahw5',
              secretId:
                  'EKy0QxlrARTM_f_lNOYfFkWxuy3_-Tuu_a8TrvVTPYK6eC-K25qJbTql7wsZ8F-KesQfKyVkrBjemv7F',
            ),
          ),

          /// Khalti payment gateway widget.
          KhaltiWidget(
            /// Passing the purchase details to generate pidx.
            pidxRequest: transactionDetails.copyWith(
                clientId: '70ac1e9ae2534d63bff4db0ab92257e2',
                secretId: '6465d7e60f3549ad93a49e61949fd94a'),
          ),

          /// eSewa payment gateway widget.
          Esewa(
            esewaPayment: transactionDetails.copyWith(
              secretId: 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
              clientId: 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
            ),
          ),

          /// Imepay payment gateway widget.
          Imepay(
            /// Passing the purchase details.

            transactionDetails: transactionDetails.copyWith(
                imepayMerchantCode: 'EDUSANJAL',
                imepayMerchantName: '',
                imepayModule: '',
                imepayUser: '',
                imepayPassword: ''),
          )
        ],
      ),
    );
  }
}
