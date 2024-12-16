import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payment_gateway_package/esewa/models/esewa_config.dart';
import 'package:payment_gateway_package/esewa/base/esewa_flutter_sdk.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment_success_response.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment_success_result.dart';
import 'package:http/http.dart' as http;

class EsewaViewmodel {
  ///Whether its test mode or not.
  bool testmode = true;

  Future<EsewaPaymentSuccessResponse> inititalizeEsewa(
      String secretId, String clientId, EsewaPayment esewaPayment) async {
    final completer = Completer<EsewaPaymentSuccessResponse>();

    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          clientId: clientId,
          secretId: secretId,
          environment: testmode ? Environment.test : Environment.live,
        ),
        esewaPayment: esewaPayment,
        onPaymentSuccess: (EsewaPaymentSuccessResult data) async {
          debugPrint(":::SUCCESS::: => $data");
          final verificationResult =
              await verifyTransactionStatus(data, clientId, secretId);
          completer.complete(verificationResult);
        },
        onPaymentFailure: (String errorMessage) {
          debugPrint(":::FAILURE::: => $errorMessage");
        },
        onPaymentCancellation: (String cancelMessage) {
          debugPrint(":::CANCELLATION::: => $cancelMessage");
        },
      );
    } catch (e) {
      debugPrint(":::EXCEPTION::: => $e");
      completer.completeError("An error occurred: $e");
    }

    return completer.future;
  }

  Future<EsewaPaymentSuccessResponse> verifyTransactionStatus(
      EsewaPaymentSuccessResult result,
      String clientId,
      String secretId) async {
    try {
      var response = await callVerificationApi(result, clientId, secretId);

      final sucResponse = response.transactionDetails?.status;
      if (sucResponse == 'COMPLETE') {
        debugPrint("Transaction is complete.");
        return response;
        // Handle success here, perhaps update UI or trigger further actions
      } else {
        throw Exception('Transaction status is not complete: ');
      }
    } catch (e) {
      throw Exception("Error verifying transaction: ${e.toString()}");
    }
  }

  Future<EsewaPaymentSuccessResponse> callVerificationApi(
      EsewaPaymentSuccessResult result,
      String clientId,
      String secretId) async {
    String url = testmode
        ? 'https://rc.esewa.com.np/mobile/transaction?txnRefId=${result.refId}'
        : 'https://esewa.com.np/mobile/transaction?txnRefId=${result.refId}';

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
