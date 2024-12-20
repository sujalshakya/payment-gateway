import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payment_gateway_package/esewa/models/esewa_config.dart';
import 'package:payment_gateway_package/esewa/base/esewa_flutter_sdk.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment_success_response.dart';
import 'package:payment_gateway_package/esewa/models/esewa_payment_success_result.dart';
import 'package:http/http.dart' as http;
import 'package:payment_gateway_package/transaction_detail_model.dart' as base;
import 'package:payment_gateway_package/result_model.dart';

class EsewaViewmodel {
  /// Indicates whether the app is in test mode or live mode.
  bool testmode = true;

  /// Initializes the eSewa payment process.
  ///
  /// Parameters:
  /// - [secretId]: The merchant's secret ID for eSewa.
  /// - [clientId]: The merchant's client ID for eSewa.
  /// - [esewaPayment]: The payment details.
  ///
  /// Returns a [Result] containing the [EsewaPaymentSuccessResponse] or an error.
  Future<Result<EsewaPaymentSuccessResponse>> initializeEsewa(String secretId,
      String clientId, base.TransactionDetails esewaPayment) async {
    final completer = Completer<Result<EsewaPaymentSuccessResponse>>();

    try {
      // Initialize the eSewa payment process.
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          clientId: clientId, // eSewa client ID.
          secretId: secretId, // eSewa secret ID.
          environment: testmode
              ? Environment.test
              : Environment.live, // Set environment.
        ),
        esewaPayment: EsewaPayment(
            productId: esewaPayment.id,
            productName: esewaPayment.orderName,
            productPrice: (esewaPayment.amount / 100).toString(),
            callbackUrl: esewaPayment.returnUrl), // Payment details.
        onPaymentSuccess: (EsewaPaymentSuccessResult data) async {
          debugPrint(":::SUCCESS::: => $data");
          // Verify the transaction status upon successful payment.
          final verificationResult =
              await verifyTransactionStatus(data, clientId, secretId);
          completer.complete(
              Result.success(verificationResult)); // Return success result.
        },
        onPaymentFailure: (String errorMessage) {
          // Handle payment failure.
          completer.complete(Result.failed(errorMessage));
        },
        onPaymentCancellation: (String cancelMessage) {
          // Handle payment cancellation.
          completer.complete(Result.cancellation(cancelMessage));
        },
      );
    } catch (e) {
      // Handle exceptions that occur during payment initialization.
      debugPrint(":::EXCEPTION::: => $e");
      completer.complete(Result.failed("An error occurred: $e"));
    }

    return completer
        .future; // Return the future that completes with the payment result.
  }

  /// Verifies the transaction status by calling the verification API.
  ///
  /// Parameters:
  /// - [result]: The payment success result containing the transaction details.
  /// - [clientId]: The merchant's client ID for eSewa.
  /// - [secretId]: The merchant's secret ID for eSewa.
  ///
  /// Returns an [EsewaPaymentSuccessResponse] if the transaction is successfully verified.
  Future<EsewaPaymentSuccessResponse> verifyTransactionStatus(
      EsewaPaymentSuccessResult result,
      String clientId,
      String secretId) async {
    try {
      // Call the transaction verification API.
      var response = await callVerificationApi(result, clientId, secretId);

      // Check if the transaction status is COMPLETE.
      final sucResponse = response.transactionDetails?.status;
      if (sucResponse == 'COMPLETE') {
        debugPrint("Transaction is complete.");
        return response; // Return the success response.
      } else {
        throw Exception('Transaction status is not complete: ');
      }
    } catch (e) {
      // Handle errors during transaction verification.
      throw Exception("Error verifying transaction: ${e.toString()}");
    }
  }

  /// Makes an API call to verify the transaction status.
  ///
  /// Parameters:
  /// - [result]: The payment success result containing the transaction reference ID.
  /// - [clientId]: The merchant's client ID for eSewa.
  /// - [secretId]: The merchant's secret ID for eSewa.
  ///
  /// Returns an [EsewaPaymentSuccessResponse] containing the transaction details.
  Future<EsewaPaymentSuccessResponse> callVerificationApi(
      EsewaPaymentSuccessResult result,
      String clientId,
      String secretId) async {
    // Construct the verification API URL based on the environment.
    String url = testmode
        ? 'https://rc.esewa.com.np/mobile/transaction?txnRefId=${result.refId}'
        : 'https://esewa.com.np/mobile/transaction?txnRefId=${result.refId}';

    // Make the GET request to the eSewa verification API.
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'merchantId': clientId, // Add client ID to the request headers.
        'merchantSecret': secretId, // Add secret ID to the request headers.
        "Content-Type": "application/json", // Specify JSON content type.
      },
    );

    // Check if the response status code is 200 (OK).
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body); // Decode the response JSON.

      // Check if the response body contains data.
      if (responseBody.isNotEmpty) {
        // Return the parsed success response.
        return EsewaPaymentSuccessResponse.fromJson(responseBody[0]);
      } else {
        throw Exception('Empty response list'); // Handle empty response error.
      }
    } else {
      throw Exception('Failed to verify transaction'); // Handle API failure.
    }
  }
}
