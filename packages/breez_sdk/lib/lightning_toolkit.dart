import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_sdk/native_toolkit.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

class LightningToolkit {
  final _lnToolkit = getNativeToolkit();

  Future<GreenlightCredentials> registerNode(
    Network network,
    Uint8List seed,
  ) async =>
      await _lnToolkit.registerNode(network: network, seed: seed);

  Future<GreenlightCredentials> recoverNode(
    Network network,
    Uint8List seed,
  ) async =>
      await _lnToolkit.recoverNode(network: network, seed: seed);

  Future createNodeServices(
    Config breezConfig,
    GreenlightCredentials creds,
    Uint8List seed,
  ) async =>
      await _lnToolkit.createNodeServices(
          breezConfig: breezConfig, creds: creds, seed: seed);

  Future startNode() async => await _lnToolkit.startNode();

  Future runSigner() async => await _lnToolkit.runSigner();

  Future stopSigner() async => await _lnToolkit.stopSigner();

  Future sync() async => await _lnToolkit.sync();

  Future<List<LspInformation>> listLsps() async => await _lnToolkit.listLsps();

  Future setLspId(String lspId) async =>
      await _lnToolkit.setLspId(lspId: lspId);

  Future<NodeState?> getNodeState() async => await _lnToolkit.getNodeState();

  Future<Map<String, Rate>> fetchRates() async {
    final List<Rate> rates = await _lnToolkit.fetchRates();
    return rates.fold<Map<String, Rate>>({}, (map, rate) {
      map[rate.coin] = rate;
      return map;
    });
  }

  Future<List<FiatCurrency>> listFiatCurrencies() async =>
      await _lnToolkit.listFiatCurrencies();

  Future<List<LightningTransaction>> listTransactions(
          PaymentTypeFilter filter) async =>
      await _lnToolkit.listTransactions(filter: filter);

  Future pay(String bolt11) async => await _lnToolkit.pay(bolt11: bolt11);

  Future keysend(String nodeId, int amountSats) async =>
      await _lnToolkit.keysend(nodeId: nodeId, amountSats: amountSats);

  Future<LNInvoice> requestPayment(int amountSats, String description) async =>
      await _lnToolkit.requestPayment(
          amountSats: amountSats, description: description);

  Future sweep(String toAddress, FeeratePreset feeratePreset) async =>
      await _lnToolkit.sweep(
          toAddress: toAddress, feeratePreset: feeratePreset);

  Future<LNInvoice> parseInvoice(String invoice) async =>
      await _lnToolkit.parseInvoice(invoice: invoice);

  Future<Uint8List> mnemonicToSeed(
          String phrase, FeeratePreset feeratePreset) async =>
      await _lnToolkit.mnemonicToSeed(phrase: phrase);
}
