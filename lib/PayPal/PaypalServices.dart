import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';


import '../screens/OrderSummaryScreen/controller/OrderSummaryScreen_controller.dart';
import '../screens/OrderSummaryScreen/widgets/PaymentMethodsWidets/PaymentMethodsWidget.dart';

class PaypalServices {
  String? domain = "https://api.paypal.com";

  // String? clientId = 'AbgZO8LMbGoO-EbECHKFhFHIG6Tap59Es9cI9tOi_Vuz8fzW-FbbPBEomkKiiOQz_etSGaFmO8ltJeK_';
  // String? secret ='EDWQa-M7BtOf8rvZXd9iqcAgJoOWwQaUs0UZIJBKzfXv-m7ZzxzIHttRwE54RqpTUckmevFX815LxLAu';

  getAccessToken() async {
    try {
      var client = BasicAuthClient(payment_methods[1]['live_public_key'],
          payment_methods[1]['live_secret_key']);
      var response = await client.post(Uri.parse(
          'https://api.sandbox.paypal.com/v1/oauth2/token?grant_type=client_credentials'));
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }

    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String?, String?>?> createPaypalPayment(
      transactions, accessToken) async {
    try {
      var response = await http.post(
          Uri.parse("https://api.sandbox.paypal.com/v1/payments/payment"),
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String? executeUrl = "";
          String? approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl!, "approvalUrl": approvalUrl!};
        }

      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

 executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(Uri.parse(url),
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });
      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body["id"];
      }

    } catch (e) {
      rethrow;
    }
  }
}
