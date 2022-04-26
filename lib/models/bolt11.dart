
import 'package:bolt11_decoder/bolt11_decoder.dart';
import 'package:fixnum/fixnum.dart';

class Bolt11 {
  final Bolt11PaymentRequest payreq;

  Bolt11._(this.payreq);

  factory Bolt11.fromPaymentRequest(String request) {
    return Bolt11._( Bolt11PaymentRequest(request));    
  }  

  Int64 get amount => Int64(payreq.amount.toInt());

  String get description => _tagValue("description") ?? "";

  String get paymentHash => _tagValue("payment_hash");

  Int64 get expiry => _tagValue("expiry");

  dynamic _tagValue(String tag) {
    var tagIndex = payreq.tags.indexWhere((f) => f.type == tag);
    if (tagIndex < 0) {
      return  null;
    }
    return payreq.tags[tagIndex].data;
  }
}