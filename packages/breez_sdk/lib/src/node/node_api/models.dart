import 'package:hex/hex.dart';

enum NodeNotificationType { PAYMENT_SUCCEED, PAYMENT_FAILED }

enum NetAddressType {
  Ipv4,
  Ipv6,
  TorV2,
  TorV3,
}

class ScheduleResponse {
  final List<int> nodeId;
  final String grpcUri;

  ScheduleResponse(this.nodeId, this.grpcUri);
}

class FileData {
  final String name;
  final List<int> content;

  FileData(this.name, this.content);
}

class NodeCredentials {
  final List<int>? nodeId;
  List<int>? secret;
  final String caCert;
  final String deviceCert;
  final String deviceKey;

  NodeCredentials(this.caCert, this.deviceCert, this.deviceKey, this.nodeId, this.secret);

  factory NodeCredentials.fromBuffer(List<int> buffer) {
    List<String> parts = String.fromCharCodes(buffer).split("***");
    return NodeCredentials(parts[0], parts[1], parts[2], HEX.decode(parts[3]), HEX.decode(parts[4]));
  }

  List<int> writeBuffer() {
    return "$caCert***$deviceCert***$deviceKey***${HEX.encode(nodeId ?? [])}***${HEX.encode(secret ?? [])}".codeUnits;
  }
}

class Address {
  final NetAddressType type;
  final String addr;
  final int port;

  Address(this.type, this.addr, this.port);

  Map<String, dynamic> toJson() => {
        'type': type,
        'addr': addr,
        'port': port,
      };
}

class NodeInfo {
  final String nodeID;
  final String nodeAlias;
  final int numPeers;
  final List<Address> addresses;
  final String version;
  final int blockheight;
  final String network;

  NodeInfo({
    required this.nodeID,
    required this.nodeAlias,
    required this.numPeers,
    required this.addresses,
    required this.version,
    required this.blockheight,
    required this.network,
  });

  Map<String, dynamic> toJson() => {
        'nodeID': nodeID,
        'nodeAlias': nodeAlias,
        'numPeers': numPeers,
        'addresses': addresses.map((a) => a.toJson()).toList(),
        'version': version,
        'blockheight': blockheight,
        'network': network,
      };
}

enum OutputStatus { CONFIRMED, UNCONFIRMED }

class Outpoint {
  final String txid;
  final int outnum;

  Outpoint(this.txid, this.outnum);

  Map<String, dynamic> toJson() => {
        'txid': txid,
        'outnum': outnum,
      };
}

class ListFundsOutput {
  final Outpoint outpoint;
  final int amountMsats;
  final String address;
  final OutputStatus status;

  ListFundsOutput({
    required this.outpoint,
    required this.amountMsats,
    required this.address,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'outpoint': outpoint.toJson(),
        'amountMsats': amountMsats.toInt(),
        'address': address,
        'status': status.name
      };
}

class ListFundsChannel {
  final String peerId;
  final bool connected;
  final int shortChannelId;
  final int ourAmountMsat;
  final int amountMsat;
  final String fundingTxid;
  final int fundingOutput;

  ListFundsChannel({
    required this.peerId,
    required this.connected,
    required this.shortChannelId,
    required this.ourAmountMsat,
    required this.amountMsat,
    required this.fundingTxid,
    required this.fundingOutput,
  });

  Map<String, dynamic> toJson() => {
        'peerId': peerId,
        'connected': connected,
        'shortChannelId': shortChannelId.toInt(),
        'ourAmountMsat': ourAmountMsat.toInt(),
        'amountMsat': amountMsat.toInt(),
        'fundingTxid': fundingTxid,
        'fundingOutput': fundingOutput
      };
}

class ListFunds {
  final List<ListFundsChannel> channelFunds;
  final List<ListFundsOutput> onchainFunds;

  ListFunds({required this.channelFunds, required this.onchainFunds});

  Map<String, dynamic> toJson() => {
        'channelFunds': channelFunds.map((c) => c.toJson()).toList(),
        'onchainFunds': onchainFunds.map((o) => o.toJson()).toList(),
      };
}

class Htlc {
  final String direction;
  final int id;
  final int amountMsat;
  final int expiry;
  final String paymentHash;
  final String state;
  final bool localTrimmed;

  Htlc({
    required this.direction,
    required this.id,
    required this.amountMsat,
    required this.expiry,
    required this.paymentHash,
    required this.state,
    required this.localTrimmed,
  });

  Map<String, dynamic> toJson() => {
        'direction': direction,
        'id': id.toInt(),
        'amountMsat': amountMsat.toInt(),
        'expiry': expiry,
        'paymentHash': paymentHash,
        'state': state,
        'localTrimmed': localTrimmed
      };
}

enum ChannelState { PENDING_OPEN, OPEN, PENDING_CLOSED, CLOSED }

class Channel {
  final ChannelState state;
  final String shortChannelId;
  final int direction;
  final String channelId;
  final String fundingTxid;
  final String closeToAddr;
  final String closeTo;
  final bool private;
  final int total;
  final int dustLimit;
  final int spendable;
  final int receivable;
  final int theirToSelfDelay;
  final int ourToSelfDelay;
  final List<Htlc> htlcs;

  Channel({
    required this.state,
    required this.shortChannelId,
    required this.direction,
    required this.channelId,
    required this.fundingTxid,
    required this.closeToAddr,
    required this.closeTo,
    required this.private,
    required this.total,
    required this.dustLimit,
    required this.spendable,
    required this.receivable,
    required this.theirToSelfDelay,
    required this.ourToSelfDelay,
    required this.htlcs,
  });

  Map<String, dynamic> toJson() => {
        'state': state.name,
        'shortChannelId': shortChannelId,
        'direction': direction,
        'channelId': channelId,
        'fundingTxid': fundingTxid,
        'closeToAddr': closeToAddr,
        'closeTo': closeTo,
        'private': private,
        'total': total,
        'dustLimit': dustLimit,
        'spendable': spendable,
        'receivable': receivable,
        'theirToSelfDelay': theirToSelfDelay,
        'ourToSelfDelay': ourToSelfDelay,
        'htlcs': htlcs.map((htlc) => htlc.toJson()).toList(),
      };
}

class Peer {
  final String id;
  final bool connected;
  final List<Address> addresses;
  final String features;
  final List<Channel> channels;

  Peer(
      {required this.id,
      required this.connected,
      required this.addresses,
      required this.features,
      required this.channels});

  Map<String, dynamic> toJson() => {
        'id': id,
        'connected': connected,
        'addresses': addresses.map((a) => a.toJson()).toList(),
        'features': features,
        'channels': channels.map((c) => c.toJson()).toList()
      };
}

enum InvoiceStatus { PAID, UNPAID, EXPIRED }

enum TransactionCostSpeed {
  economy,
  regular,
  priority,
}

class Withdrawal {
  final String txid;
  final String tx;

  Withdrawal(this.txid, this.tx);
}

class Invoice {
  final String label;
  final int amountMsats;
  final int receivedMsats;
  final String description;
  final InvoiceStatus status;
  final int paymentTime;
  final int expiryTime;
  final String bolt11;
  final String paymentPreimage;
  final String paymentHash;

  Invoice({
    required this.amountMsats,
    required this.label,
    required this.description,
    required this.receivedMsats,
    required this.status,
    required this.paymentTime,
    required this.expiryTime,
    required this.bolt11,
    required this.paymentPreimage,
    required this.paymentHash,
  });

  Invoice copyWithNewAmount(
      {required int amountMsats, required String bolt11}) {
    return Invoice(
      amountMsats: amountMsats,
      label: label,
      description: description,
      receivedMsats: receivedMsats,
      status: status,
      paymentTime: paymentTime,
      expiryTime: expiryTime,
      bolt11: bolt11,
      paymentPreimage: paymentPreimage,
      paymentHash: paymentHash,
    );
  }

  String get payeeImageURL => "";

  String get payeeName => "";

  int get lspFee => 0;

  Map<String, dynamic> toJson() => {
        'amountMsats': amountMsats.toInt(),
        'label': label,
        'description': description,
        'receivedMsats': receivedMsats.toInt(),
        'status': status.name,
        'paymentTime': paymentTime,
        'expiryTime': expiryTime,
        'bolt11': bolt11,
        'paymentPreimage': paymentPreimage,
        'paymentHash': paymentHash,
      };
}

class OutgoingLightningPayment {
  final int creationTimestamp;
  final String paymentHash;
  final String destination;
  final int feeMsats;
  final int amountMsats;
  final int amountSentMsats;
  final String preimage;
  final bool isKeySend;
  final bool pending;
  final String bolt11;

  OutgoingLightningPayment({
    required this.creationTimestamp,
    required this.paymentHash,
    required this.destination,
    required this.feeMsats,
    required this.amountMsats,
    required this.amountSentMsats,
    required this.preimage,
    required this.isKeySend,
    required this.pending,
    required this.bolt11,
  });

  Map<String, dynamic> toJson() => {
        'creationTimestamp': creationTimestamp,
        'paymentHash': paymentHash,
        'destination': destination,
        'feeMsats': feeMsats.toInt(),
        'amountMsats': amountMsats.toInt(),
        'amountSentMsats': amountSentMsats.toInt(),
        'preimage': preimage,
        'isKeySend': isKeySend,
        'pending': pending,
        'bolt11': bolt11
      };
}

class TlvField {
  final int type;
  final String value;

  TlvField({required this.type, required this.value});
}

class IncomingLightningPayment {
  final String label;
  final String preimage;
  final int amountMsats;
  final List<TlvField> extratlvs;
  final String paymentHash;
  final String bolt11;

  IncomingLightningPayment({
    required this.label,
    required this.preimage,
    required this.amountMsats,
    required this.extratlvs,
    required this.paymentHash,
    required this.bolt11,
  });
}
