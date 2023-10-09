import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/input/input_source.dart';
import 'package:c_breez/models/invoice.dart';

class InputState {
  const InputState._();

  const factory InputState.empty() = EmptyInputState;

  const factory InputState.loading() = LoadingInputState;

  const factory InputState.invoice(
    Invoice invoice,
    InputSource source,
  ) = InvoiceInputState;

  const factory InputState.lnUrlPay(
    LnUrlPayRequestData data,
    InputSource source,
  ) = LnUrlPayInputState;

  const factory InputState.lnUrlWithdraw(
    LnUrlWithdrawRequestData data,
    InputSource source,
  ) = LnUrlWithdrawInputState;

  const factory InputState.lnUrlAuth(
    LnUrlAuthRequestData data,
    InputSource source,
  ) = LnUrlAuthInputState;

  const factory InputState.lnUrlError(
    LnUrlErrorData data,
    InputSource source,
  ) = LnUrlErrorInputState;

  const factory InputState.nodeId(
    String nodeId,
    InputSource source,
  ) = NodeIdInputState;

  const factory InputState.bitcoinAddress(
    BitcoinAddressData data,
    InputSource source,
  ) = BitcoinAddressInputState;

  const factory InputState.url(
    String url,
    InputSource source,
  ) = UrlInputState;
}

class EmptyInputState extends InputState {
  const EmptyInputState() : super._();

  @override
  String toString() {
    return 'EmptyInputState{}';
  }
}

class LoadingInputState extends InputState {
  const LoadingInputState() : super._();

  @override
  String toString() {
    return 'LoadingInputState{}';
  }
}

class InvoiceInputState extends InputState {
  const InvoiceInputState(
    this.invoice,
    this.source,
  ) : super._();

  final Invoice invoice;
  final InputSource source;

  @override
  String toString() {
    return 'InvoiceInputState{invoice: $invoice, source: $source}';
  }
}

class LnUrlPayInputState extends InputState {
  const LnUrlPayInputState(
    this.data,
    this.source,
  ) : super._();

  final LnUrlPayRequestData data;
  final InputSource source;

  @override
  String toString() {
    return 'LnUrlPayInputState{data: $data, source: $source}';
  }
}

class LnUrlWithdrawInputState extends InputState {
  const LnUrlWithdrawInputState(
    this.data,
    this.source,
  ) : super._();

  final LnUrlWithdrawRequestData data;
  final InputSource source;

  @override
  String toString() {
    return 'LnUrlWithdrawInputState{data: $data, source: $source}';
  }
}

class LnUrlAuthInputState extends InputState {
  const LnUrlAuthInputState(
    this.data,
    this.source,
  ) : super._();

  final LnUrlAuthRequestData data;
  final InputSource source;

  @override
  String toString() {
    return 'LnUrlAuthInputState{data: $data, source: $source}';
  }
}

class LnUrlErrorInputState extends InputState {
  const LnUrlErrorInputState(
    this.data,
    this.source,
  ) : super._();

  final LnUrlErrorData data;
  final InputSource source;

  @override
  String toString() {
    return 'LnUrlErrorInputState{data: $data, source: $source}';
  }
}

class NodeIdInputState extends InputState {
  const NodeIdInputState(
    this.nodeId,
    this.source,
  ) : super._();

  final String nodeId;
  final InputSource source;

  @override
  String toString() {
    return 'NodeIdInputState{nodeId: $nodeId, source: $source}';
  }
}

class BitcoinAddressInputState extends InputState {
  const BitcoinAddressInputState(
    this.data,
    this.source,
  ) : super._();

  final BitcoinAddressData data;
  final InputSource source;

  @override
  String toString() {
    return 'BitcoinAddressInputState{data: $data, source: $source}';
  }
}

class UrlInputState extends InputState {
  const UrlInputState(
    this.url,
    this.source,
  ) : super._();

  final String url;
  final InputSource source;

  @override
  String toString() {
    return 'UrlInputState{url: $url, source: $source}';
  }
}
