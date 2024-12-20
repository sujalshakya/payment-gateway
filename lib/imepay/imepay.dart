import 'package:flutter/material.dart';
import 'package:imepay_merchant_sdk/start_sdk.dart';
import 'package:payment_gateway_package/imepay/imepay_model.dart';
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

  /// Imepay specific data such as  merchantCode, merchantName, module, user, password;
  final ImePayModel transaction;

  /// function to trigger on success of payment.

  final Function(Object?) onSuccess;

  /// ImePay integration widget.
  const Imepay({
    this.testmode = true,
    super.key,
    required this.transactionDetails,
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
              merchantUrl: widget.transactionDetails.websiteUrl,
              amount: (widget.transactionDetails.amount / 100).toString(),
              customerName: widget.transaction.user,
              refId: widget.transactionDetails.id,
              module: widget.transaction.module,
              user: widget.transaction.user,
              password: widget.transaction.password,
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
