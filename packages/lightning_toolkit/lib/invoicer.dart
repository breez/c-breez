
import 'bridge_generated.dart';
import 'lightning_toolkit.dart';

class Invoicer {
  final _lnToolkit = getLightningToolkit();

  Invoicer();

  Future<LNInvoice> parseInvoice({required String invoice, dynamic hint}) {
    return _lnToolkit.parseInvoice(invoice: invoice);
  }
}
