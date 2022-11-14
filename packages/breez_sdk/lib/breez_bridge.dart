import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_sdk/native_toolkit.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

class BreezBridge {
  final _lnToolkit = getNativeToolkit();

  /// Register a new node in the cloud and return credentials to interact with it
  ///
  /// # Arguments
  ///
  /// * `network` - The network type which is one of (Bitcoin, Testnet, Signet, Regtest)
  /// * `seed` - The node private key
  Future<GreenlightCredentials> registerNode({
    required Network network,
    required Uint8List seed,
  }) async =>
      await _lnToolkit.registerNode(network: network, seed: seed);

  /// Recover an existing node from the cloud and return credentials to interact with it
  ///
  /// # Arguments
  ///
  /// * `network` - The network type which is one of (Bitcoin, Testnet, Signet, Regtest)
  /// * `seed` - The node private key
  Future<GreenlightCredentials> recoverNode({
    required Network network,
    required Uint8List seed,
  }) async =>
      await _lnToolkit.recoverNode(network: network, seed: seed);

  /// init_node initialized the global NodeService, schedule the node to run in the cloud and
  /// run the signer. This must be called in order to start comunicate with the node
  ///
  /// # Arguments
  ///
  /// * `breezConfig` - the sdk coniguration
  /// * `seed` - The node private key
  /// * `creds` -
  Future initNode({
    required Config breezConfig,
    required Uint8List seed,
    required GreenlightCredentials creds,
  }) async =>
      await _lnToolkit.initNode(
        breezConfig: breezConfig,
        seed: seed,
        creds: creds,
      );

  /// pay a bolt11 invoice
  ///
  /// # Arguments
  ///
  /// * `bolt11` - The bolt11 invoice
  Future sendPayment({required String bolt11}) async =>
      await _lnToolkit.sendPayment(bolt11: bolt11);

  /// pay directly to a node id using keysend
  ///
  /// # Arguments
  ///
  /// * `nodeId` - The destination nodeId
  /// * `amountSats` - The amount to pay in satoshis
  Future sendSpontaneousPayment(
          {required String nodeId, required int amountSats}) async =>
      await _lnToolkit.sendSpontaneousPayment(
          nodeId: nodeId, amountSats: amountSats);

  /// Creates an bolt11 payment request.
  /// This also works when the node doesn't have any channels and need inbound liquidity.
  /// In such case when the invoice is paid a new zero-conf channel will be open by the LSP,
  /// providing inbound liquidity and the payment will be routed via this new channel.
  ///
  /// # Arguments
  ///
  /// * `amountSats` - The amount to receive in satoshis
  /// * `description` - The bolt11 payment request description
  Future<LNInvoice> receivePayment(
          {required int amountSats, required String description}) async =>
      await _lnToolkit.receivePayment(
          amountSats: amountSats, description: description);

  /// get the node state from the persistent storage
  Future<NodeState?> getNodeState() async => await _lnToolkit.getNodeState();

  Stream<NodeState?> get nodeStateStream => getNodeState().asStream();

  /// list transactions (incoming/outgoing payments) from the persistent storage
  Future<List<LightningTransaction>> listTransactions({
    PaymentTypeFilter filter = PaymentTypeFilter.All,
    int? fromTimestamp,
    int? toTimestamp,
  }) async =>
      await _lnToolkit.listTransactions(
        filter: filter,
        fromTimestamp: fromTimestamp,
        toTimestamp: toTimestamp,
      );

  /// List available lsps that can be selected by the user
  Future<List<LspInformation>> listLsps() async => await _lnToolkit.listLsps();

  /// Select the lsp to be used and provide inbound liquidity
  Future setLspId(String lspId) async =>
      await _lnToolkit.setLspId(lspId: lspId);

  /// Fetch live rates of fiat currencies
  Future<Map<String, Rate>> fetchRates() async {
    final List<Rate> rates = await _lnToolkit.fetchRates();
    return rates.fold<Map<String, Rate>>({}, (map, rate) {
      map[rate.coin] = rate;
      return map;
    });
  }

  /// List all available fiat currencies
  Future<List<FiatCurrency>> listFiatCurrencies() async =>
      await _lnToolkit.listFiatCurrencies();

  /// close all channels with the current lsp
  Future closeLspChannels() async => await _lnToolkit.closeLspChannels();

  /// Withdraw on-chain funds in the wallet to an external btc address
  Future withdraw(
          {required String toAddress,
          required FeeratePreset feeratePreset}) async =>
      await _lnToolkit.withdraw(
          toAddress: toAddress, feeratePreset: feeratePreset);

  Future<LNInvoice> parseInvoice(String invoice) async =>
      await _lnToolkit.parseInvoice(invoice: invoice);

  /// Attempts to convert the phrase to a mnemonic, then to a seed.
  ///
  /// If the phrase is not a valid mnemonic, an error is returned.
  Future<Uint8List> mnemonicToSeed(String phrase) async =>
      await _lnToolkit.mnemonicToSeed(phrase: phrase);
}
