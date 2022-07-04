import 'dart:convert';

import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:http/http.dart' as http;

Future<LNURLPayResult> getPaymentResult(LNURLPayParams parseResult, Map<String, String> qParams) async {
  /*
     5. LN WALLET makes a GET request using
        <callback><?|&>amount=<milliSatoshi>
        amount being the amount specified by the user in millisatoshis.
   */
  Uri uri = Uri.parse(parseResult.callback).replace(queryParameters: qParams);
  var response = await http.get(uri).timeout(const Duration(seconds: 60));
  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Failed to call ${parseResult.domain} API');
  }
  /*
   6. LN Service takes the GET request and returns JSON response of form:
      {
        pr: string, // bech32-serialized lightning invoice
        routes: [] // an empty array
        "successAction": Object (optional)
      }
      or
      {"status":"ERROR", "reason":"error details..."}
  */
  Map<String, dynamic> decoded = json.decode(response.body);
  return LNURLPayResult.fromJson(decoded);
}
