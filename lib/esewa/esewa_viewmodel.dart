import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payment_gateway_package/esewa/models/esewa_config.dart';
import 'package:payment_gateway_package/esewa/models/esewa_flutter_sdk.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment_success_response.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment_success_result.dart';
import 'package:http/http.dart' as http;

class EsewaViewmodel {
  bool testmode = true;

  void esewa(String secretId, String clientId, EsewaPayment esewaPayment) {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
            clientId: clientId,
            secretId: secretId,
            environment: Environment.test),
        esewaPayment: esewaPayment,
        onPaymentSuccess: (EsewaPaymentSuccessResult data) {
          debugPrint(":::SUCCESS::: => $data");
          verifyTransactionStatus(data, clientId, secretId);
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

  Future<void> verifyTransactionStatus(EsewaPaymentSuccessResult result,
      String clientId, String secretId) async {
    try {
      var response = await callVerificationApi(result, clientId, secretId);

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
      EsewaPaymentSuccessResult result,
      String clientId,
      String secretId) async {
    String url =
        'https://rc.esewa.com.np/mobile/transaction?txnRefId=${result.refId}';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'merchantId': clientId,
        'merchantSecret': secretId,
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
}
