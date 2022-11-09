import 'dart:async';

import 'package:breez_sdk/native_toolkit.dart';
import 'package:breez_sdk/sdk.dart';
import 'package:breez_sdk/src/breez_server/generated/breez.pbgrpc.dart';
import 'package:breez_sdk/src/breez_server/server.dart';
import 'package:breez_sdk/src/btc_swapper/swap_address.dart';
import 'package:breez_sdk/src/storage/dao/db.dart' as db;
import 'package:fimber/fimber.dart';

class BTCSwapper {
  static const maxDepositAmount = 4000000;
  
  final _log = FimberLog("BTCSwapper");
  final _lnToolkit = getNativeToolkit();
  final LightningNode _node;
  final Storage _storage;
  final ChainService _chainService;

  BTCSwapper(this._node, this._storage, this._chainService);  

  // Creating a new swap address
  Future<String> createSwap() async {
    throw Exception("Under revision.");
    /*
    if (_node.currentLSP == null) {
      throw Exception("lsp is not set");
    }
    final currentLSP = _node.currentLSP!;

    // create swap keys
    final swapKeys = await _lnToolkit.createSwap();
    final nodeInfo = await _node.getNodeState();

    // call breez server to get a sub swap address
    final server = await BreezServer.createWithDefaultConfig();
    var channel = await server.createServerChannel();
    var fundingClient = FundManagerClient(channel, options: server.defaultCallOptions);
    final createSwapInitRequest = AddFundInitRequest()
      ..hash = swapKeys.hash
      ..nodeID = nodeInfo!.id
      ..pubkey = swapKeys.pubkey;
    final createSwapInitReply = await fundingClient.addFundInit(createSwapInitRequest);
    final script = await _lnToolkit.createSubmaringSwapScript(
        hash: swapKeys.hash,
        swapperPubKey: Uint8List.fromList(createSwapInitReply.pubkey),
        payerPubKey: swapKeys.pubkey,
        lockHeight: createSwapInitReply.lockHeight.toInt());

    final swap = db.Swap(
      createdTimestamp: DateTime.now().millisecondsSinceEpoch,
      lspid: currentLSP.lspID,
      lockHeight: createSwapInitReply.lockHeight.toInt(),
      bitcoinAddress: createSwapInitReply.address,
      paymentHash: swapKeys.hash,
      preimage: swapKeys.preimage,
      privateKey: swapKeys.privkey,
      publicKey: swapKeys.pubkey,
      paidSats: 0,
      confirmedSats: 0,
      script: script,
    );
    await _storage.addSwap(swap);

    return swap.bitcoinAddress;
     */
  }

  // Fetch all swaps
  Future getSwaps() async {
    return _storage.listSwaps();
  }

  // Redeem a pending swap. This means we create an invoice and ask from the
  // swapper to pay us in exchange to the preimage for spending the onchain utxo
  Future redeem(SwapLiveData liveSwap) async {
    await _node.getNodeAPI().ensureScheduled();
    var s = liveSwap.swap;
    try {
      if (s.paymentRequest == null) {
        _log.i("creating payment request for address: ${s.bitcoinAddress}");
        final invoice = await _createSwapInvoice(liveSwap.confirmedAmount);
        s = await _storage.updateSwap(s.bitcoinAddress, payreq: invoice.bolt11);
      } else {
        _log.i("found payment request for address: ${s.bitcoinAddress}");
      }
      final invoice = await _lnToolkit.parseInvoice(invoice: s.paymentRequest!);
      if (invoice.amountMsat != null && invoice.amountMsat! != liveSwap.confirmedAmount) {
        _log.e("Funds were added after invoice was created for address: ${s.bitcoinAddress}");
        throw Exception("Funds were added after invoice was created");
      }

      final server = await BreezServer.createWithDefaultConfig();
      var channel = await server.createServerChannel();
      var swapper = SwapperClient(channel, options: server.defaultCallOptions);
      final swapResponse = await swapper.getSwapPayment(GetSwapPaymentRequest()..paymentRequest = s.paymentRequest!);
      s = await _storage.updateSwap(s.bitcoinAddress, error: swapResponse.paymentError);
      _log.i("swap finished successfully for address: ${s.bitcoinAddress}");
      _node.syncState();
    } catch (e) {
      _log.i("error in completing swap for address: ${s.bitcoinAddress} error=${e.toString()}");
      s = await _storage.updateSwap(s.bitcoinAddress, error: e.toString());
    }
  }

  // Refund
  Future refund(db.Swap s) async {}

  Future redeemPendingSwaps() async {
    final liveSwaps = await _refreshSwapsStatuses();
    return Future.wait(liveSwaps.map(redeem));
  }

  Future<LNInvoice> _createSwapInvoice(int confirmedSats) async {
    return _lnToolkit.requestPayment(amountSats: confirmedSats, description: "");
  }

  Future<List<SwapLiveData>> _refreshSwapsStatuses() async {
    final swaps = await _storage.listSwaps();
    final liveSwaps = List<SwapLiveData>.empty(growable: true);
    _log.i("list swaps returned ${swaps.length} swaps addresses");
    for (var s in swaps) {      
      if (s.paidSats == 0 && s.refundTxIds == null) {
        _log.i("now fetching ${s.bitcoinAddress} adress"); 
        final txs = await _chainService.fetchTransactionsForAddress(s.bitcoinAddress);
        _log.i("fetched ${txs.length} transactions for address: ${s.bitcoinAddress}"); 
        final liveData = SwapLiveData(s, txs);
        _log.i("address: ${s.bitcoinAddress} redeemable = ${liveData.redeemable}"); 
        if (liveData.redeemable) {
          liveSwaps.add(liveData);
        }
      }
    }
    return liveSwaps;
  }
}

// class SwapperException implements Exception {
//   final String errorMessage;
//   final SwapErrorCode errorCode;

//   SwapperException(this.errorMessage, this.errorCode);

//   @override
//   String toString() {
//     return "Error in swap: $errorMessage code:$errorCode";
//   }
//}
