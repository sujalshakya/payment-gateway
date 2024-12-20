import 'package:flutter/material.dart';
import 'package:imepay_merchant_sdk/start_sdk.dart';
import 'package:payment_gateway_package/transaction_detail_model.dart';

class Imepay extends StatefulWidget {
  /// Width of logo.

  final double? width;

  /// Whether it is for testing or not, true on default.
  final bool testmode;

  /// Height of logo.

  final double? height;

  /// Details about the product such as product id, price, name and return url.

  final TransactionDetails transactionDetails;

  /// ImePay integration widget.
  const Imepay({
    this.testmode = true,
    super.key,
    required this.transactionDetails,
    this.height,
    this.width,
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
              merchantCode: widget.transactionDetails.imepayMerchantCode ?? "",
              merchantName: widget.transactionDetails.imepayMerchantName ?? "",
              merchantUrl: widget.transactionDetails.websiteUrl,
              amount: (widget.transactionDetails.amount / 100).toString(),
              customerName: widget.transactionDetails.imepayUser ?? "",
              refId: widget.transactionDetails.id,
              module: widget.transactionDetails.imepayModule ?? "",
              user: widget.transactionDetails.imepayUser ?? "",
              password: widget.transactionDetails.imepayPassword ?? "",
              userAssetImage: '',
              deliveryUrl: widget.transactionDetails.returnUrl,
              buildType: widget.testmode ? BuildType.STAGE : BuildType.LIVE);
          debugPrint(result.toString());
        },
        child: Image.asset("assets/images/imepay.png",
            width: widget.width ?? 50,
            height: widget.height ?? 50,
            package: 'payment_gateway_package'));
  }
}
