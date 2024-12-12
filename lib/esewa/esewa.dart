import 'dart:convert';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment_success_response.dart';

void esewa() {
  try {
    EsewaFlutterSdk.initPayment(
      esewaConfig: EsewaConfig(
        environment: Environment.test,
        clientId: 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
        secretId: 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
      ),
      esewaPayment: EsewaPayment(
        productId: "1d71jd81",
        productName: "Product One",
        productPrice: "20",
        callbackUrl: 'www.google.com',
      ),
      onPaymentSuccess: (EsewaPaymentSuccessResult data) {
        debugPrint(":::SUCCESS::: => $data");
        verifyTransactionStatus(data);
      },
      onPaymentFailure: (data) {
        debugPrint(":::FAILURE::: => $data");
      },
      onPaymentCancellation: (data) {
        debugPrint(":::CANCELLATION::: => $data");
      },
    );
  } on Exception catch (e) {
    debugPrint("EXCEPTION : ${e.toString()}");
  }
}

Future<void> verifyTransactionStatus(EsewaPaymentSuccessResult result) async {
  try {
    var response = await callVerificationApi(result);

    final sucResponse = response.transactionDetails?.status;
    if (sucResponse == 'COMPLETE') {
      debugPrint("Transaction is complete.");
      // Handle success here, perhaps update UI or trigger further actions
    } else {
      debugPrint("Transaction status is not complete: ");
    }
  } catch (e) {
    debugPrint("Error verifying transaction: ${e.toString()}");
  }
}

Future<EsewaPaymentSuccessResponse> callVerificationApi(
    EsewaPaymentSuccessResult result) async {
  String url =
      'https://rc.esewa.com.np/mobile/transaction?txnRefId=${result.refId}';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'merchantId': 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
      'merchantSecret': 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    var responseBody = jsonDecode(response.body);

    if (responseBody.isNotEmpty) {
      return EsewaPaymentSuccessResponse.fromJson(responseBody[0]);
    } else {
      throw Exception('Empty response list');
    }
  } else {
    throw Exception('Failed to verify transaction');
  }
}
