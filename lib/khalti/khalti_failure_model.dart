import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';

class KhaltiFailureModel {
  final int? statusCode;
  final Object? description;
  final KhaltiEvent? event;
  final bool? needsPaymentConfirmation;

  KhaltiFailureModel(
      {this.statusCode,
      this.description,
      this.event,
      this.needsPaymentConfirmation});
}
