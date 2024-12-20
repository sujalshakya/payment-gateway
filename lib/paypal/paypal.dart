import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:payment_gateway_package/success_response.dart';
import 'package:payment_gateway_package/transaction_detail_model.dart';

class Paypal extends StatelessWidget {
  const Paypal({
    super.key,
    this.height,
    this.width,
    this.testmode = true,
    required this.transactionDetails,
  });

  /// Whether it is for testing or not, true on default.
  final bool testmode;

  /// Details about the product such as product id, price, name and callback url.
  /// Esewa sends a proof of payment in the callback-URL after successful payment in live environment.
  final TransactionDetails transactionDetails;

  /// Height of logo.

  final double? height;

  /// Width of logo.
  final double? width;

  /// eSewa payment integration widget.

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => UsePaypal(
                      sandboxMode: testmode ? true : false,
                      clientId: transactionDetails.clientId,
                      secretKey: transactionDetails.secretId,
                      returnURL: transactionDetails.returnUrl,
                      cancelURL: transactionDetails.websiteUrl,
                      transactions: [
                        {
                          "amount": {
                            "total": transactionDetails.amount,
                            "currency": 'USD',
                          },
                          "description": "The payment transaction description.",
                          "item_list": {
                            "items": [
                              {
                                "name": transactionDetails.orderName,
                                "quantity": 1,
                                "price": transactionDetails.amount,
                                "currency": "USD"
                              }
                            ],
                          }
                        }
                      ],
                      note: "Contact us for any questions on your order.",
                      onSuccess: (Map params) async {
                        debugPrint("Success: $params");
                        transactionDetails.onSuccess(SuccessResponse(
                            transactionId: params["data"]["id"],
                            orderName: params["data"]["transactions"][0]
                                ["item_list"]["items"][0]["name"],
                            totalAmount: params["data"]["transactions"][0]
                                ["amount"]["total"],
                            status: params["status"],
                            time: params["data"]["create_time"]));
                      },
                      onError: (error) {
                        debugPrint("onError: $error");
                        transactionDetails.onFailure(error.toString());
                      },
                      onCancel: (params) {
                        debugPrint('cancelled: $params');
                        transactionDetails.onCancellation(
                            'The Process was cancelled by user');
                      }),
                ),
              )
            },
        child: Image.asset(
          'assets/images/paypal.png',
          package: 'payment_gateway_package',
          height: height ?? 40,
          width: width ?? 40,
        ));
  }
}
