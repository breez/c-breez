import 'package:c_breez/models/invoice.dart';
import 'package:dart_lnurl/dart_lnurl.dart';

class InputState {
  final Invoice? invoice;
  final LNURLParseResult? lnurlParseResult;

  InputState({this.invoice, this.lnurlParseResult});
}
