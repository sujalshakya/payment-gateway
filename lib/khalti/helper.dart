import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> generatePidx() async {
  const String khaltiApiUrl = 'https://a.khalti.com/api/v2/epayment/initiate/';

  final Map<String, dynamic> requestPayload = {
    "return_url": "http://google.com/",
    "website_url": "http://google.com/",
    "amount": "1000",
    "purchase_order_id": "Order01",
    "purchase_order_name": "Test",
    "customer_info": {
      "name": "Test",
      "email": "test@khalti.com",
      "phone": "9800000001"
    }
  };

  try {
    final response = await http.post(
      Uri.parse(khaltiApiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Key 6465d7e60f3549ad93a49e61949fd94a"
      },
      body: jsonEncode(requestPayload),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['pidx']; // Return the generated pidx
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
