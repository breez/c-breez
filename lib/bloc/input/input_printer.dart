import 'package:breez_sdk/sdk.dart';

class InputPrinter {
  const InputPrinter();

  String inputTypeToString(InputType inputType) {
    if (inputType is InputType_BitcoinAddress) {
      return _bitcoinAddressToString(inputType);
    } else if (inputType is InputType_Bolt11) {
      return _bolt11ToString(inputType);
    } else if (inputType is InputType_NodeId) {
      return _nodeIdToString(inputType);
    } else if (inputType is InputType_Url) {
      return _urlToString(inputType);
    } else if (inputType is InputType_LnUrlPay) {
      return _lnUrlPayToString(inputType);
    } else if (inputType is InputType_LnUrlWithdraw) {
      return _lnUrlWithdrawToString(inputType);
    } else if (inputType is InputType_LnUrlAuth) {
      return _lnUrlAuthToString(inputType);
    } else if (inputType is InputType_LnUrlError) {
      return _lnUrlErrorToString(inputType);
    } else {
      return "Unknown InputType";
    }
  }

  String _bitcoinAddressToString(InputType_BitcoinAddress inputType) {
    final data = inputType.address;
    return "BitcoinAddress(address: ${data.address}, network: ${data.network}, amountSat: ${data.amountSat}, "
        "label: ${data.label}, message: ${data.message})";
  }

  String _bolt11ToString(InputType_Bolt11 inputType) {
    final data = inputType.invoice;
    return "Bolt11(invoice: ${data.bolt11}, paymentHash: ${data.paymentHash}, "
        "description: ${data.description}, amountMsat: ${data.amountMsat}, expiry: ${data.expiry}, "
        "payeePubkey: ${data.payeePubkey}, descriptionHash: ${data.descriptionHash}, "
        "timestamp: ${data.timestamp}, routingHints: ${data.routingHints}, "
        "paymentSecret: ${data.paymentSecret})";
  }

  String _nodeIdToString(InputType_NodeId inputType) {
    return "NodeId(nodeId: ${inputType.nodeId})";
  }

  String _urlToString(InputType_Url inputType) {
    return "Url(url: ${inputType.url})";
  }

  String _lnUrlPayToString(InputType_LnUrlPay inputType) {
    final data = inputType.data;
    return "LnUrlPayRequestData(callback: ${data.callback}, minSendable: ${data.minSendable}, "
        "maxSendable: ${data.maxSendable}, metadata: ${data.metadataStr}, "
        "commentAllowed: ${data.commentAllowed}, domain: ${data.domain}, lnAddr: ${data.lnAddress})";
  }

  String _lnUrlWithdrawToString(InputType_LnUrlWithdraw inputType) {
    final data = inputType.data;
    return "LnUrlWithdrawRequestData(callback: ${data.callback}, minWithdrawable: ${data.minWithdrawable}, "
        "maxWithdrawable: ${data.maxWithdrawable}, defaultDescription: ${data.defaultDescription}, "
        "k1: ${data.k1})";
  }

  String _lnUrlAuthToString(InputType_LnUrlAuth inputType) {
    final data = inputType.data;
    return "LnUrlAuthRequestData(k1: ${data.k1}, action: ${data.action}, domain: ${data.domain}, "
        "url: ${data.url})";
  }

  String _lnUrlErrorToString(InputType_LnUrlError inputType) {
    final data = inputType.data;
    return "LnUrlError(reason: ${data.reason})";
  }
}
