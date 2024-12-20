# Payment Gateway Package

Allows payment through esewa, khalti ...

```
 TransactionDetails(

        /// URL to return after payment. Details of the transaction is sent to this url.

        returnUrl: 'https://www.google.com/',

        /// URL for the website.
        websiteUrl: 'https://www.google.com/',

        /// Amount for the transaction.

        amount: 1000,

        /// Unique purchase  / transaction ID.

        id: '1',

        /// Name of the order.

        orderName: 'Test');

```

## Khalti

Khalti requires pidx() which is generated as soon as the the khalti widget is initiated and when the khalti widget is tapped khalti webview is opened.

### Live

Get clientId and SecretId for live from:

[Khalti Live](https://admin.khalti.com/)

### Test

Get clientId and SecretId for test from:

[Khalti Test](https://test-admin.khalti.com/#/join/merchant)

- Test Credentials

```
    KhaltiId 9800000000 9800000001 9800000002 9800000003 9800000004 9800000005

    MPIN 1111

    OTP 987654
```

### Example

```
KhaltiWidget(
            /// Public key for Khalti API.

            publicKey: '70ac1e9ae2534d63bff4db0ab92257e2',

            /// Secret key for Khalti API.

            secretKey: '6465d7e60f3549ad93a49e61949fd94a',

            /// Handle success.

            onSuccess: (response) {
              debugPrint("onSuccess ${response!.payload!.status}");
            },

            /// Handle failure.

            onFailure: (response) {
              debugPrint("onFailure ${response.needsPaymentConfirmation}");
            },

            /// Passing the purchase details to generate pidx.

            pidxRequest: purchaseDetailModel,

          ),

```

## Esewa

### Android Configuration

- Android Gradle plugin version should be above 7.
- Go to your project's root folder
- Go to android folder > app > src > main > AndroidManifest.xml

inside tag

```

android:theme="@style/Theme.AppCompat.Light.NoActionBar"

<uses-permission android:name="android.permission.INTERNET"/>

<application
        android:label="your_app"
        android:theme="@style/Theme.AppCompat.Light.NoActionBar"
        android:icon="@mipmap/ic_launcher">

```

### IOS Configuration

IOS uses two different framework for release/App Store builds and simulator/testing builds.

- Step-1

  RELEASE | Copy the ios folder from IOS_RELEASE directory to esewa_flutter_sdk folder

  SIMULATOR | Copy the ios folder from IOS_SIMULATOR directory to esewa_flutter_sdk folder

- Step-2

  Open terminal in your project's ios module path and run pod install and restart your XCODE( Not doing this will show esewa_flutter_sdk import error in GeneratedPluginRegistrant.m file)

  WARNING: Your IOS app won't build if you use the build designed for simulator in release/App Store builds.

### Example

```
 Esewa(
            /// Secret ID for eSewa.

            secretId: 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',

            /// Client ID for eSewa.

            clientId: 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',

            /// Passing the purchase details.

            esewaPayment: purchaseDetailModel,

            //// Function triggered on successful payment.
            onSuccess: (result) =>
                debugPrint("onsuccesss${result.merchantName}"),

            //// Function triggered on failure of payment.
            onFailure: (message) => debugPrint("onFailure $message"),

            //// Function triggered on cancellation of payment.
            onCancellation: (message) => debugPrint("onCancellation $message"),
          ),

```

## IMEPay

TODO

## Additional information
