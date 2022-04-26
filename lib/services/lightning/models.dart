import 'package:fixnum/fixnum.dart';
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
  final List<int>? nodePrivateKey;
  final List<int>? nodeId;
  List<int>? secret;
  final String caCert;
  final String deviceCert;
  final String deviceKey;

  NodeCredentials(this.caCert, this.deviceCert, this.deviceKey, this.nodeId,
      this.nodePrivateKey, this.secret);

  factory NodeCredentials.fromBuffer(List<int> buffer) {
    List<String> parts = String.fromCharCodes(buffer).split("***");
    return NodeCredentials(parts[0], parts[1], parts[2], HEX.decode(parts[3]),
        HEX.decode(parts[4]), HEX.decode(parts[5]));
  }

  List<int> writeBuffer() {
    return "$caCert***$deviceCert***$deviceKey***${HEX.encode(nodeId ?? [])}***${HEX.encode(nodePrivateKey ?? [])}***${HEX.encode(secret ?? [])}"
        .codeUnits;
  }
}

class Address {
  final NetAddressType type;
  final String addr;
  final int port;

  Address(this.type, this.addr, this.port);
}

class NodeInfo {
  final String nodeID;
  final String nodeAlias;
  final int numPeers;
  final List<Address> addresses;
  final String version;
  final int blockheight;
  final String network;

  NodeInfo(
      {required this.nodeID,
      required this.nodeAlias,
      required this.numPeers,
      required this.addresses,
      required this.version,
      required this.blockheight,
      required this.network});
}

enum OutputStatus { CONFIRMED, UNCONFIRMED }

class Outpoint {
  final String txid;
  final int outnum;

  Outpoint(this.txid, this.outnum);
}

class ListFundsOutput {
  final Outpoint outpoint;
  final Int64 amount;
  final String address;
  final OutputStatus status;

  ListFundsOutput(
      {required this.outpoint,
      required this.amount,
      required this.address,
      required this.status});
}

class ListFundsChannel {
  final String peerId;
  final bool connected;
  final Int64 shortChannelId;
  final Int64 ourAmountMsat;
  final Int64 amountMsat;
  final String fundingTxid;
  final int fundingOutput;

  ListFundsChannel(
      {required this.peerId,
      required this.connected,
      required this.shortChannelId,
      required this.ourAmountMsat,
      required this.amountMsat,
      required this.fundingTxid,
      required this.fundingOutput});
}

class ListFunds {
  final List<ListFundsChannel> channelFunds;
  final List<ListFundsOutput> onchainFunds;

  ListFunds({required this.channelFunds, required this.onchainFunds});
}

class Htlc {
  final String direction;
  final Int64 id;
  final Int64 amountMsat;
  final int expiry;
  final String paymentHash;
  final String state;
  final bool localTrimmed;

  Htlc(
      {required this.direction,
      required this.id,
      required this.amountMsat,
      required this.expiry,
      required this.paymentHash,
      required this.state,
      required this.localTrimmed});
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
  final String total;
  final String dustLimit;
  final String spendable;
  final String receivable;
  final int theirToSelfDelay;
  final int ourToSelfDelay;
  final List<Htlc> htlcs;

  Channel(
      {required this.state,
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
      required this.htlcs});
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
}

enum InvoiceStatus { PAID, UNPAID, EXPIRED }

class Withdrawal {
  final String txid;
  final String tx;

  Withdrawal(this.txid, this.tx);
}

class Invoice {
  final String label;
  final Int64 amountSats;
  final Int64 received;
  final String description;
  final InvoiceStatus status;
  final int paymentTime;
  final int expiryTime;
  final String bolt11;
  final String paymentPreimage;
  final String paymentHash;

  Invoice(
      {required this.amountSats,
      required this.label,
      required this.description,
      required this.received,
      required this.status,
      required this.paymentTime,
      required this.expiryTime,
      required this.bolt11,
      required this.paymentPreimage,
      required this.paymentHash});

  String get payeeImageURL => "";
  String get payeeName => "";
  Int64 get lspFee => Int64(0);
}

class OutgoingLightningPayment {
  final int creationTimestamp;
  final String paymentHash;
  final String destination;
  final Int64 fee;
  final Int64 amount;
  final Int64 amountSent;
  final String preimage;
  final bool isKeySend;
  final bool pending;
  final String bolt11;

  OutgoingLightningPayment(
      {required this.creationTimestamp,
      required this.paymentHash,
      required this.destination,
      required this.fee,
      required this.amount,
      required this.amountSent,
      required this.preimage,
      required this.isKeySend,
      required this.pending,
      required this.bolt11});
}

class TlvField {
  final int type;
  final String value;

  TlvField({required this.type, required this.value});
}

class IncomingLightningPayment {
  final String label;
  final String preimage;
  final Int64 amountSat;
  final List<TlvField> extratlvs;
  final String paymentHash;
  final String bolt11;

  IncomingLightningPayment(
      {required this.label,
      required this.preimage,
      required this.amountSat,
      required this.extratlvs,
      required this.paymentHash,
      required this.bolt11});
}
