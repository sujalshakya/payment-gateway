import 'package:flutter/material.dart';
import 'package:payment_gateway_package/esewa/esewa.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment.dart';
import 'package:payment_gateway_package/khalti/khalti.dart';
import 'package:payment_gateway_package/khalti/helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                generatePidx();
              },
              child: const Text("Generate Pidx")),
          KhaltiSDKDemo(
            pidx: 'HGikCgwE8WL9qQKSXR3WbC',
            publicKey: '70ac1e9ae2534d63bff4db0ab92257e2',
            onSuccess: (p0) {
              debugPrint("onSuccess ${p0?.payload?.status}");
            },
            onFailure: (p0) {
              debugPrint("onFailure ${p0.needsPaymentConfirmation}");
            },
          ),
          Esewa(
            secretId: 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
            clientId: 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
            esewaPayment: EsewaPayment(
              productId: '1',
              productName: 'String',
              productPrice: '1000',
              callbackUrl: 'www.google.com',
            ),
            onSuccess: (result) =>
                debugPrint("onsuccesss${result.merchantName}"),
            onFailure: (message) => debugPrint("onFailure $message"),
            onCancellation: (message) => debugPrint("onCancellation $message}"),
          ),
        ],
      ),
    );
  }
}
