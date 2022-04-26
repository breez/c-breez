///
//  Generated code. Do not modify.
//  source: greenlight.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class NetAddressType extends $pb.ProtobufEnum {
  static const NetAddressType Ipv4 = NetAddressType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'Ipv4');
  static const NetAddressType Ipv6 = NetAddressType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'Ipv6');
  static const NetAddressType TorV2 = NetAddressType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TorV2');
  static const NetAddressType TorV3 = NetAddressType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TorV3');

  static const $core.List<NetAddressType> values = <NetAddressType> [
    Ipv4,
    Ipv6,
    TorV2,
    TorV3,
  ];

  static final $core.Map<$core.int, NetAddressType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static NetAddressType? valueOf($core.int value) => _byValue[value];

  const NetAddressType._($core.int v, $core.String n) : super(v, n);
}

class BtcAddressType extends $pb.ProtobufEnum {
  static const BtcAddressType BECH32 = BtcAddressType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BECH32');
  static const BtcAddressType P2SH_SEGWIT = BtcAddressType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'P2SH_SEGWIT');

  static const $core.List<BtcAddressType> values = <BtcAddressType> [
    BECH32,
    P2SH_SEGWIT,
  ];

  static final $core.Map<$core.int, BtcAddressType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static BtcAddressType? valueOf($core.int value) => _byValue[value];

  const BtcAddressType._($core.int v, $core.String n) : super(v, n);
}

class OutputStatus extends $pb.ProtobufEnum {
  static const OutputStatus CONFIRMED = OutputStatus._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CONFIRMED');
  static const OutputStatus UNCONFIRMED = OutputStatus._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNCONFIRMED');

  static const $core.List<OutputStatus> values = <OutputStatus> [
    CONFIRMED,
    UNCONFIRMED,
  ];

  static final $core.Map<$core.int, OutputStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OutputStatus? valueOf($core.int value) => _byValue[value];

  const OutputStatus._($core.int v, $core.String n) : super(v, n);
}

class FeeratePreset extends $pb.ProtobufEnum {
  static const FeeratePreset NORMAL = FeeratePreset._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NORMAL');
  static const FeeratePreset SLOW = FeeratePreset._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SLOW');
  static const FeeratePreset URGENT = FeeratePreset._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'URGENT');

  static const $core.List<FeeratePreset> values = <FeeratePreset> [
    NORMAL,
    SLOW,
    URGENT,
  ];

  static final $core.Map<$core.int, FeeratePreset> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FeeratePreset? valueOf($core.int value) => _byValue[value];

  const FeeratePreset._($core.int v, $core.String n) : super(v, n);
}

class CloseChannelType extends $pb.ProtobufEnum {
  static const CloseChannelType MUTUAL = CloseChannelType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MUTUAL');
  static const CloseChannelType UNILATERAL = CloseChannelType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNILATERAL');

  static const $core.List<CloseChannelType> values = <CloseChannelType> [
    MUTUAL,
    UNILATERAL,
  ];

  static final $core.Map<$core.int, CloseChannelType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CloseChannelType? valueOf($core.int value) => _byValue[value];

  const CloseChannelType._($core.int v, $core.String n) : super(v, n);
}

class InvoiceStatus extends $pb.ProtobufEnum {
  static const InvoiceStatus UNPAID = InvoiceStatus._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNPAID');
  static const InvoiceStatus PAID = InvoiceStatus._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PAID');
  static const InvoiceStatus EXPIRED = InvoiceStatus._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EXPIRED');

  static const $core.List<InvoiceStatus> values = <InvoiceStatus> [
    UNPAID,
    PAID,
    EXPIRED,
  ];

  static final $core.Map<$core.int, InvoiceStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static InvoiceStatus? valueOf($core.int value) => _byValue[value];

  const InvoiceStatus._($core.int v, $core.String n) : super(v, n);
}

class PayStatus extends $pb.ProtobufEnum {
  static const PayStatus PENDING = PayStatus._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PENDING');
  static const PayStatus COMPLETE = PayStatus._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMPLETE');
  static const PayStatus FAILED = PayStatus._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FAILED');

  static const $core.List<PayStatus> values = <PayStatus> [
    PENDING,
    COMPLETE,
    FAILED,
  ];

  static final $core.Map<$core.int, PayStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PayStatus? valueOf($core.int value) => _byValue[value];

  const PayStatus._($core.int v, $core.String n) : super(v, n);
}

