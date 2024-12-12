import 'package:flutter/material.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';

class KhaltiViewmodel extends ChangeNotifier {
  late final Future<Khalti?> khalti;

  String pidx = "xWvmArSG8kHccababcEjok";
  bool pop = false;

  PaymentResult? paymentResult;
  void initializeKhalti() {
    final payConfig = KhaltiPayConfig(
      publicKey: '70ac1e9ae2534d63bff4db0ab92257e2',
      pidx: pidx,
      environment: Environment.test,
    );
    khalti = Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,
      onPaymentResult: (paymentResult, khalti) {
        paymentResult = paymentResult;
        notifyListeners();
      },
      onMessage: (
        khalti, {
        description,
        statusCode,
        event,
        needsPaymentConfirmation,
      }) async {
        notifyListeners();
      },
    );
  }
}
