import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:payment_gateway_package/esewa/models/esewa_config.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment_success_result.dart';
import 'constants.dart';

class EsewaFlutterSdk {
  static const MethodChannel _channel = MethodChannel(methodChannelName);

  static void showToast(String message) {
    _channel.invokeMethod('showToast', {"message": message});
  }

  static void initPayment({
    required EsewaConfig esewaConfig,
    required EsewaPayment esewaPayment,
    required Function(EsewaPaymentSuccessResult) onPaymentSuccess,
    required Function onPaymentFailure,
    required Function onPaymentCancellation,
  }) {
    _channel.invokeMethod('initPayment', _buildArgs(esewaConfig, esewaPayment));
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case paymentMethodSuccess:
          debugPrint(":::METHOD CALL RESULT SUCCESS");
          final Map<String, dynamic> result;
          if (Platform.isIOS) {
            result = Map<String, dynamic>.from(call.arguments);
          } else {
            result = json.decode(call.arguments);
          }
          final EsewaPaymentSuccessResult paymentResult =
              EsewaPaymentSuccessResult(
            productId: result["productID"] ?? result["productId"],
            productName: result["productName"],
            totalAmount: result["totalAmount"],
            environment: result["environment"],
            code: result["code"],
            merchantName: result["merchantName"],
            message: result["message"]["successMessage"],
            status: result["transactionDetails"]["status"],
            date: result["transactionDetails"]["date"],
            refId: result["transactionDetails"]["referenceId"],
          );
          onPaymentSuccess(paymentResult);
          break;
        case paymentMethodFailure:
          debugPrint(":::METHOD CALL RESULT FAILURE");
          onPaymentFailure(call.arguments);
          break;
        case paymentMethodCancellation:
          debugPrint(":::METHOD CALL RESULT CANCELLATION");
          onPaymentCancellation(call.arguments);
          break;
      }
    });
  }

  static Map<String, dynamic> _buildArgs(
    EsewaConfig esewaConfig,
    EsewaPayment esewaPayment,
  ) =>
      {
        argsKeyConfig: esewaConfig.toMap(),
        argsKeyPayment: esewaPayment.toMap(),
      };
}
