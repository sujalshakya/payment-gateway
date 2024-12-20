import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payment_gateway_package/transaction_detail_model.dart';
import 'package:payment_gateway_package/khalti/khalti_pidx_response.dart';

Future<KhaltiPidxResponse?> generatePidx(
    TransactionDetails request, bool testMode, String secretKey) async {
  String khaltiApiUrl = testMode
      ? 'https://a.khalti.com/api/v2/epayment/initiate/'
      : 'https://khalti.com/api/v2/epayment/initiate/';
  try {
    final response = await http.post(
      Uri.parse(khaltiApiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Key $secretKey",
      },
      body: jsonEncode({
        "return_url": request.returnUrl,
        "website_url": request.websiteUrl,
        "amount": request.amount,
        "purchase_order_id": request.id,
        "purchase_order_name": request.orderName,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return KhaltiPidxResponse.fromJson(responseBody);
    } else {
      debugPrint("Error: ${response.statusCode} - ${response.body}");
      return null;
    }
  } catch (e) {
    debugPrint("Exception: $e");
    return null;
  }
}
