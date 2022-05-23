import 'package:c_breez/models/payment_type.dart';
import 'package:fixnum/fixnum.dart';

class PaymentInfo {
  final PaymentType type;
  final Int64 amountMsat;
  final Int64 feeMsat;
  final Int64? creationTimestamp;
  final bool keySend;
  final String paymentHash;
  final String? preimage;
  final String destination;
  final bool pending;
  final Int64? pendingExpirationTimestamp;
  final String description;
  final String longTitle;
  final String shortTitle;
  final String? imageURL;

  const PaymentInfo({
    required this.type,
    required this.amountMsat,
    required this.feeMsat,
    required this.creationTimestamp,
    this.pending = false,
    this.keySend = false,
    required this.paymentHash,
    this.preimage,
    required this.destination,
    this.pendingExpirationTimestamp,
    this.description = "",
    this.longTitle = "",
    required this.shortTitle,
    this.imageURL,
  });

  Int64? get amountSat => amountMsat ~/ 1000;
  Int64 get feeSat => feeMsat ~/ 1000;
}
