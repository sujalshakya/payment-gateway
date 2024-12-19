import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:imepay_merchant_sdk/start_sdk.dart';
import 'package:payment_gateway_package/imepay/imepay_model.dart';
import 'package:payment_gateway_package/khalti/khalti_pidx_request.dart';

class Imepay extends StatefulWidget {
  /// Width of logo.

  final double? width;

  /// Whether it is for testing or not, true on default.
  final bool testmode;

  /// Height of logo.

  final double? height;
  final PurchaseDetailModel purchaseDetailModel;
  final ImePayModel transaction;

  /// function to trigger on success of payment.

  final Function(Object?) onSuccess;

  const Imepay({
    this.testmode = true,
    super.key,
    required this.purchaseDetailModel,
    this.height,
    this.width,
    required this.onSuccess,
    required this.transaction,
  });

  @override
  State<Imepay> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Imepay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          var result = await StartSdk.callSdk(context,
              merchantCode: widget.transaction.merchantCode,
              merchantName: widget.transaction.merchantName,
              merchantUrl: widget.purchaseDetailModel.websiteUrl,
              amount: (widget.purchaseDetailModel.amount / 100).toString(),
              refId: widget.purchaseDetailModel.purchaseOrderId,
              module: widget.transaction.module,
              user: widget.transaction.user,
              password: widget.transaction.password,
              deliveryUrl: widget.purchaseDetailModel.returnUrl,
              buildType: widget.testmode ? BuildType.STAGE : BuildType.LIVE);

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(content: Text(json.encode(result)));
            },
          );
        },
        child: Image.asset("assets/images/imepay.png",
            width: widget.width ?? 50,
            height: widget.height ?? 50,
            package: 'payment_gateway_package'));
  }
}
