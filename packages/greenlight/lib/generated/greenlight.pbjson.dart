///
//  Generated code. Do not modify.
//  source: greenlight.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use netAddressTypeDescriptor instead')
const NetAddressType$json = const {
  '1': 'NetAddressType',
  '2': const [
    const {'1': 'Ipv4', '2': 0},
    const {'1': 'Ipv6', '2': 1},
    const {'1': 'TorV2', '2': 2},
    const {'1': 'TorV3', '2': 3},
  ],
};

/// Descriptor for `NetAddressType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List netAddressTypeDescriptor = $convert.base64Decode('Cg5OZXRBZGRyZXNzVHlwZRIICgRJcHY0EAASCAoESXB2NhABEgkKBVRvclYyEAISCQoFVG9yVjMQAw==');
@$core.Deprecated('Use btcAddressTypeDescriptor instead')
const BtcAddressType$json = const {
  '1': 'BtcAddressType',
  '2': const [
    const {'1': 'BECH32', '2': 0},
    const {'1': 'P2SH_SEGWIT', '2': 1},
  ],
};

/// Descriptor for `BtcAddressType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List btcAddressTypeDescriptor = $convert.base64Decode('Cg5CdGNBZGRyZXNzVHlwZRIKCgZCRUNIMzIQABIPCgtQMlNIX1NFR1dJVBAB');
@$core.Deprecated('Use outputStatusDescriptor instead')
const OutputStatus$json = const {
  '1': 'OutputStatus',
  '2': const [
    const {'1': 'CONFIRMED', '2': 0},
    const {'1': 'UNCONFIRMED', '2': 1},
  ],
};

/// Descriptor for `OutputStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List outputStatusDescriptor = $convert.base64Decode('CgxPdXRwdXRTdGF0dXMSDQoJQ09ORklSTUVEEAASDwoLVU5DT05GSVJNRUQQAQ==');
@$core.Deprecated('Use feeratePresetDescriptor instead')
const FeeratePreset$json = const {
  '1': 'FeeratePreset',
  '2': const [
    const {'1': 'NORMAL', '2': 0},
    const {'1': 'SLOW', '2': 1},
    const {'1': 'URGENT', '2': 2},
  ],
};

/// Descriptor for `FeeratePreset`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List feeratePresetDescriptor = $convert.base64Decode('Cg1GZWVyYXRlUHJlc2V0EgoKBk5PUk1BTBAAEggKBFNMT1cQARIKCgZVUkdFTlQQAg==');
@$core.Deprecated('Use closeChannelTypeDescriptor instead')
const CloseChannelType$json = const {
  '1': 'CloseChannelType',
  '2': const [
    const {'1': 'MUTUAL', '2': 0},
    const {'1': 'UNILATERAL', '2': 1},
  ],
};

/// Descriptor for `CloseChannelType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List closeChannelTypeDescriptor = $convert.base64Decode('ChBDbG9zZUNoYW5uZWxUeXBlEgoKBk1VVFVBTBAAEg4KClVOSUxBVEVSQUwQAQ==');
@$core.Deprecated('Use invoiceStatusDescriptor instead')
const InvoiceStatus$json = const {
  '1': 'InvoiceStatus',
  '2': const [
    const {'1': 'UNPAID', '2': 0},
    const {'1': 'PAID', '2': 1},
    const {'1': 'EXPIRED', '2': 2},
  ],
};

/// Descriptor for `InvoiceStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List invoiceStatusDescriptor = $convert.base64Decode('Cg1JbnZvaWNlU3RhdHVzEgoKBlVOUEFJRBAAEggKBFBBSUQQARILCgdFWFBJUkVEEAI=');
@$core.Deprecated('Use payStatusDescriptor instead')
const PayStatus$json = const {
  '1': 'PayStatus',
  '2': const [
    const {'1': 'PENDING', '2': 0},
    const {'1': 'COMPLETE', '2': 1},
    const {'1': 'FAILED', '2': 2},
  ],
};

/// Descriptor for `PayStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List payStatusDescriptor = $convert.base64Decode('CglQYXlTdGF0dXMSCwoHUEVORElORxAAEgwKCENPTVBMRVRFEAESCgoGRkFJTEVEEAI=');
@$core.Deprecated('Use hsmRequestContextDescriptor instead')
const HsmRequestContext$json = const {
  '1': 'HsmRequestContext',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 12, '10': 'nodeId'},
    const {'1': 'dbid', '3': 2, '4': 1, '5': 4, '10': 'dbid'},
    const {'1': 'capabilities', '3': 3, '4': 1, '5': 4, '10': 'capabilities'},
  ],
};

/// Descriptor for `HsmRequestContext`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hsmRequestContextDescriptor = $convert.base64Decode('ChFIc21SZXF1ZXN0Q29udGV4dBIXCgdub2RlX2lkGAEgASgMUgZub2RlSWQSEgoEZGJpZBgCIAEoBFIEZGJpZBIiCgxjYXBhYmlsaXRpZXMYAyABKARSDGNhcGFiaWxpdGllcw==');
@$core.Deprecated('Use hsmResponseDescriptor instead')
const HsmResponse$json = const {
  '1': 'HsmResponse',
  '2': const [
    const {'1': 'request_id', '3': 1, '4': 1, '5': 13, '10': 'requestId'},
    const {'1': 'raw', '3': 2, '4': 1, '5': 12, '10': 'raw'},
  ],
};

/// Descriptor for `HsmResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hsmResponseDescriptor = $convert.base64Decode('CgtIc21SZXNwb25zZRIdCgpyZXF1ZXN0X2lkGAEgASgNUglyZXF1ZXN0SWQSEAoDcmF3GAIgASgMUgNyYXc=');
@$core.Deprecated('Use hsmRequestDescriptor instead')
const HsmRequest$json = const {
  '1': 'HsmRequest',
  '2': const [
    const {'1': 'request_id', '3': 1, '4': 1, '5': 13, '10': 'requestId'},
    const {'1': 'context', '3': 2, '4': 1, '5': 11, '6': '.greenlight.HsmRequestContext', '10': 'context'},
    const {'1': 'raw', '3': 3, '4': 1, '5': 12, '10': 'raw'},
  ],
};

/// Descriptor for `HsmRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hsmRequestDescriptor = $convert.base64Decode('CgpIc21SZXF1ZXN0Eh0KCnJlcXVlc3RfaWQYASABKA1SCXJlcXVlc3RJZBI3Cgdjb250ZXh0GAIgASgLMh0uZ3JlZW5saWdodC5Ic21SZXF1ZXN0Q29udGV4dFIHY29udGV4dBIQCgNyYXcYAyABKAxSA3Jhdw==');
@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = const {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode('CgVFbXB0eQ==');
@$core.Deprecated('Use addressDescriptor instead')
const Address$json = const {
  '1': 'Address',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.greenlight.NetAddressType', '10': 'type'},
    const {'1': 'addr', '3': 2, '4': 1, '5': 9, '10': 'addr'},
    const {'1': 'port', '3': 3, '4': 1, '5': 13, '10': 'port'},
  ],
};

/// Descriptor for `Address`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addressDescriptor = $convert.base64Decode('CgdBZGRyZXNzEi4KBHR5cGUYASABKA4yGi5ncmVlbmxpZ2h0Lk5ldEFkZHJlc3NUeXBlUgR0eXBlEhIKBGFkZHIYAiABKAlSBGFkZHISEgoEcG9ydBgDIAEoDVIEcG9ydA==');
@$core.Deprecated('Use getInfoRequestDescriptor instead')
const GetInfoRequest$json = const {
  '1': 'GetInfoRequest',
};

/// Descriptor for `GetInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getInfoRequestDescriptor = $convert.base64Decode('Cg5HZXRJbmZvUmVxdWVzdA==');
@$core.Deprecated('Use getInfoResponseDescriptor instead')
const GetInfoResponse$json = const {
  '1': 'GetInfoResponse',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 12, '10': 'nodeId'},
    const {'1': 'alias', '3': 2, '4': 1, '5': 9, '10': 'alias'},
    const {'1': 'color', '3': 3, '4': 1, '5': 12, '10': 'color'},
    const {'1': 'num_peers', '3': 4, '4': 1, '5': 13, '10': 'numPeers'},
    const {'1': 'addresses', '3': 5, '4': 3, '5': 11, '6': '.greenlight.Address', '10': 'addresses'},
    const {'1': 'version', '3': 6, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'blockheight', '3': 7, '4': 1, '5': 13, '10': 'blockheight'},
    const {'1': 'network', '3': 8, '4': 1, '5': 9, '10': 'network'},
  ],
};

/// Descriptor for `GetInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getInfoResponseDescriptor = $convert.base64Decode('Cg9HZXRJbmZvUmVzcG9uc2USFwoHbm9kZV9pZBgBIAEoDFIGbm9kZUlkEhQKBWFsaWFzGAIgASgJUgVhbGlhcxIUCgVjb2xvchgDIAEoDFIFY29sb3ISGwoJbnVtX3BlZXJzGAQgASgNUghudW1QZWVycxIxCglhZGRyZXNzZXMYBSADKAsyEy5ncmVlbmxpZ2h0LkFkZHJlc3NSCWFkZHJlc3NlcxIYCgd2ZXJzaW9uGAYgASgJUgd2ZXJzaW9uEiAKC2Jsb2NraGVpZ2h0GAcgASgNUgtibG9ja2hlaWdodBIYCgduZXR3b3JrGAggASgJUgduZXR3b3Jr');
@$core.Deprecated('Use stopRequestDescriptor instead')
const StopRequest$json = const {
  '1': 'StopRequest',
};

/// Descriptor for `StopRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopRequestDescriptor = $convert.base64Decode('CgtTdG9wUmVxdWVzdA==');
@$core.Deprecated('Use stopResponseDescriptor instead')
const StopResponse$json = const {
  '1': 'StopResponse',
};

/// Descriptor for `StopResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopResponseDescriptor = $convert.base64Decode('CgxTdG9wUmVzcG9uc2U=');
@$core.Deprecated('Use connectRequestDescriptor instead')
const ConnectRequest$json = const {
  '1': 'ConnectRequest',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    const {'1': 'addr', '3': 2, '4': 1, '5': 9, '10': 'addr'},
  ],
};

/// Descriptor for `ConnectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectRequestDescriptor = $convert.base64Decode('Cg5Db25uZWN0UmVxdWVzdBIXCgdub2RlX2lkGAEgASgJUgZub2RlSWQSEgoEYWRkchgCIAEoCVIEYWRkcg==');
@$core.Deprecated('Use connectResponseDescriptor instead')
const ConnectResponse$json = const {
  '1': 'ConnectResponse',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    const {'1': 'features', '3': 2, '4': 1, '5': 9, '10': 'features'},
  ],
};

/// Descriptor for `ConnectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectResponseDescriptor = $convert.base64Decode('Cg9Db25uZWN0UmVzcG9uc2USFwoHbm9kZV9pZBgBIAEoCVIGbm9kZUlkEhoKCGZlYXR1cmVzGAIgASgJUghmZWF0dXJlcw==');
@$core.Deprecated('Use listPeersRequestDescriptor instead')
const ListPeersRequest$json = const {
  '1': 'ListPeersRequest',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
  ],
};

/// Descriptor for `ListPeersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPeersRequestDescriptor = $convert.base64Decode('ChBMaXN0UGVlcnNSZXF1ZXN0EhcKB25vZGVfaWQYASABKAlSBm5vZGVJZA==');
@$core.Deprecated('Use htlcDescriptor instead')
const Htlc$json = const {
  '1': 'Htlc',
  '2': const [
    const {'1': 'direction', '3': 1, '4': 1, '5': 9, '10': 'direction'},
    const {'1': 'id', '3': 2, '4': 1, '5': 4, '10': 'id'},
    const {'1': 'amount', '3': 3, '4': 1, '5': 9, '10': 'amount'},
    const {'1': 'expiry', '3': 4, '4': 1, '5': 4, '10': 'expiry'},
    const {'1': 'payment_hash', '3': 5, '4': 1, '5': 9, '10': 'paymentHash'},
    const {'1': 'state', '3': 6, '4': 1, '5': 9, '10': 'state'},
    const {'1': 'local_trimmed', '3': 7, '4': 1, '5': 8, '10': 'localTrimmed'},
  ],
};

/// Descriptor for `Htlc`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List htlcDescriptor = $convert.base64Decode('CgRIdGxjEhwKCWRpcmVjdGlvbhgBIAEoCVIJZGlyZWN0aW9uEg4KAmlkGAIgASgEUgJpZBIWCgZhbW91bnQYAyABKAlSBmFtb3VudBIWCgZleHBpcnkYBCABKARSBmV4cGlyeRIhCgxwYXltZW50X2hhc2gYBSABKAlSC3BheW1lbnRIYXNoEhQKBXN0YXRlGAYgASgJUgVzdGF0ZRIjCg1sb2NhbF90cmltbWVkGAcgASgIUgxsb2NhbFRyaW1tZWQ=');
@$core.Deprecated('Use channelDescriptor instead')
const Channel$json = const {
  '1': 'Channel',
  '2': const [
    const {'1': 'state', '3': 1, '4': 1, '5': 9, '10': 'state'},
    const {'1': 'owner', '3': 2, '4': 1, '5': 9, '10': 'owner'},
    const {'1': 'short_channel_id', '3': 3, '4': 1, '5': 9, '10': 'shortChannelId'},
    const {'1': 'direction', '3': 4, '4': 1, '5': 13, '10': 'direction'},
    const {'1': 'channel_id', '3': 5, '4': 1, '5': 9, '10': 'channelId'},
    const {'1': 'funding_txid', '3': 6, '4': 1, '5': 9, '10': 'fundingTxid'},
    const {'1': 'close_to_addr', '3': 7, '4': 1, '5': 9, '10': 'closeToAddr'},
    const {'1': 'close_to', '3': 8, '4': 1, '5': 9, '10': 'closeTo'},
    const {'1': 'private', '3': 9, '4': 1, '5': 8, '10': 'private'},
    const {'1': 'total', '3': 10, '4': 1, '5': 9, '10': 'total'},
    const {'1': 'dust_limit', '3': 11, '4': 1, '5': 9, '10': 'dustLimit'},
    const {'1': 'spendable', '3': 12, '4': 1, '5': 9, '10': 'spendable'},
    const {'1': 'receivable', '3': 13, '4': 1, '5': 9, '10': 'receivable'},
    const {'1': 'their_to_self_delay', '3': 14, '4': 1, '5': 13, '10': 'theirToSelfDelay'},
    const {'1': 'our_to_self_delay', '3': 15, '4': 1, '5': 13, '10': 'ourToSelfDelay'},
    const {'1': 'status', '3': 16, '4': 3, '5': 9, '10': 'status'},
    const {'1': 'htlcs', '3': 17, '4': 3, '5': 11, '6': '.greenlight.Htlc', '10': 'htlcs'},
  ],
};

/// Descriptor for `Channel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelDescriptor = $convert.base64Decode('CgdDaGFubmVsEhQKBXN0YXRlGAEgASgJUgVzdGF0ZRIUCgVvd25lchgCIAEoCVIFb3duZXISKAoQc2hvcnRfY2hhbm5lbF9pZBgDIAEoCVIOc2hvcnRDaGFubmVsSWQSHAoJZGlyZWN0aW9uGAQgASgNUglkaXJlY3Rpb24SHQoKY2hhbm5lbF9pZBgFIAEoCVIJY2hhbm5lbElkEiEKDGZ1bmRpbmdfdHhpZBgGIAEoCVILZnVuZGluZ1R4aWQSIgoNY2xvc2VfdG9fYWRkchgHIAEoCVILY2xvc2VUb0FkZHISGQoIY2xvc2VfdG8YCCABKAlSB2Nsb3NlVG8SGAoHcHJpdmF0ZRgJIAEoCFIHcHJpdmF0ZRIUCgV0b3RhbBgKIAEoCVIFdG90YWwSHQoKZHVzdF9saW1pdBgLIAEoCVIJZHVzdExpbWl0EhwKCXNwZW5kYWJsZRgMIAEoCVIJc3BlbmRhYmxlEh4KCnJlY2VpdmFibGUYDSABKAlSCnJlY2VpdmFibGUSLQoTdGhlaXJfdG9fc2VsZl9kZWxheRgOIAEoDVIQdGhlaXJUb1NlbGZEZWxheRIpChFvdXJfdG9fc2VsZl9kZWxheRgPIAEoDVIOb3VyVG9TZWxmRGVsYXkSFgoGc3RhdHVzGBAgAygJUgZzdGF0dXMSJgoFaHRsY3MYESADKAsyEC5ncmVlbmxpZ2h0Lkh0bGNSBWh0bGNz');
@$core.Deprecated('Use peerDescriptor instead')
const Peer$json = const {
  '1': 'Peer',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 12, '10': 'id'},
    const {'1': 'connected', '3': 2, '4': 1, '5': 8, '10': 'connected'},
    const {'1': 'addresses', '3': 3, '4': 3, '5': 11, '6': '.greenlight.Address', '10': 'addresses'},
    const {'1': 'features', '3': 4, '4': 1, '5': 9, '10': 'features'},
    const {'1': 'channels', '3': 5, '4': 3, '5': 11, '6': '.greenlight.Channel', '10': 'channels'},
  ],
};

/// Descriptor for `Peer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List peerDescriptor = $convert.base64Decode('CgRQZWVyEg4KAmlkGAEgASgMUgJpZBIcCgljb25uZWN0ZWQYAiABKAhSCWNvbm5lY3RlZBIxCglhZGRyZXNzZXMYAyADKAsyEy5ncmVlbmxpZ2h0LkFkZHJlc3NSCWFkZHJlc3NlcxIaCghmZWF0dXJlcxgEIAEoCVIIZmVhdHVyZXMSLwoIY2hhbm5lbHMYBSADKAsyEy5ncmVlbmxpZ2h0LkNoYW5uZWxSCGNoYW5uZWxz');
@$core.Deprecated('Use listPeersResponseDescriptor instead')
const ListPeersResponse$json = const {
  '1': 'ListPeersResponse',
  '2': const [
    const {'1': 'peers', '3': 1, '4': 3, '5': 11, '6': '.greenlight.Peer', '10': 'peers'},
  ],
};

/// Descriptor for `ListPeersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPeersResponseDescriptor = $convert.base64Decode('ChFMaXN0UGVlcnNSZXNwb25zZRImCgVwZWVycxgBIAMoCzIQLmdyZWVubGlnaHQuUGVlclIFcGVlcnM=');
@$core.Deprecated('Use disconnectRequestDescriptor instead')
const DisconnectRequest$json = const {
  '1': 'DisconnectRequest',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    const {'1': 'force', '3': 2, '4': 1, '5': 8, '10': 'force'},
  ],
};

/// Descriptor for `DisconnectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disconnectRequestDescriptor = $convert.base64Decode('ChFEaXNjb25uZWN0UmVxdWVzdBIXCgdub2RlX2lkGAEgASgJUgZub2RlSWQSFAoFZm9yY2UYAiABKAhSBWZvcmNl');
@$core.Deprecated('Use disconnectResponseDescriptor instead')
const DisconnectResponse$json = const {
  '1': 'DisconnectResponse',
};

/// Descriptor for `DisconnectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disconnectResponseDescriptor = $convert.base64Decode('ChJEaXNjb25uZWN0UmVzcG9uc2U=');
@$core.Deprecated('Use newAddrRequestDescriptor instead')
const NewAddrRequest$json = const {
  '1': 'NewAddrRequest',
  '2': const [
    const {'1': 'address_type', '3': 1, '4': 1, '5': 14, '6': '.greenlight.BtcAddressType', '10': 'addressType'},
  ],
};

/// Descriptor for `NewAddrRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List newAddrRequestDescriptor = $convert.base64Decode('Cg5OZXdBZGRyUmVxdWVzdBI9CgxhZGRyZXNzX3R5cGUYASABKA4yGi5ncmVlbmxpZ2h0LkJ0Y0FkZHJlc3NUeXBlUgthZGRyZXNzVHlwZQ==');
@$core.Deprecated('Use newAddrResponseDescriptor instead')
const NewAddrResponse$json = const {
  '1': 'NewAddrResponse',
  '2': const [
    const {'1': 'address_type', '3': 1, '4': 1, '5': 14, '6': '.greenlight.BtcAddressType', '10': 'addressType'},
    const {'1': 'address', '3': 2, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `NewAddrResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List newAddrResponseDescriptor = $convert.base64Decode('Cg9OZXdBZGRyUmVzcG9uc2USPQoMYWRkcmVzc190eXBlGAEgASgOMhouZ3JlZW5saWdodC5CdGNBZGRyZXNzVHlwZVILYWRkcmVzc1R5cGUSGAoHYWRkcmVzcxgCIAEoCVIHYWRkcmVzcw==');
@$core.Deprecated('Use listFundsRequestDescriptor instead')
const ListFundsRequest$json = const {
  '1': 'ListFundsRequest',
  '2': const [
    const {'1': 'minconf', '3': 1, '4': 1, '5': 11, '6': '.greenlight.Confirmation', '10': 'minconf'},
  ],
};

/// Descriptor for `ListFundsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFundsRequestDescriptor = $convert.base64Decode('ChBMaXN0RnVuZHNSZXF1ZXN0EjIKB21pbmNvbmYYASABKAsyGC5ncmVlbmxpZ2h0LkNvbmZpcm1hdGlvblIHbWluY29uZg==');
@$core.Deprecated('Use listFundsOutputDescriptor instead')
const ListFundsOutput$json = const {
  '1': 'ListFundsOutput',
  '2': const [
    const {'1': 'output', '3': 1, '4': 1, '5': 11, '6': '.greenlight.Outpoint', '10': 'output'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 11, '6': '.greenlight.Amount', '10': 'amount'},
    const {'1': 'address', '3': 4, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'status', '3': 5, '4': 1, '5': 14, '6': '.greenlight.OutputStatus', '10': 'status'},
  ],
};

/// Descriptor for `ListFundsOutput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFundsOutputDescriptor = $convert.base64Decode('Cg9MaXN0RnVuZHNPdXRwdXQSLAoGb3V0cHV0GAEgASgLMhQuZ3JlZW5saWdodC5PdXRwb2ludFIGb3V0cHV0EioKBmFtb3VudBgCIAEoCzISLmdyZWVubGlnaHQuQW1vdW50UgZhbW91bnQSGAoHYWRkcmVzcxgEIAEoCVIHYWRkcmVzcxIwCgZzdGF0dXMYBSABKA4yGC5ncmVlbmxpZ2h0Lk91dHB1dFN0YXR1c1IGc3RhdHVz');
@$core.Deprecated('Use listFundsChannelDescriptor instead')
const ListFundsChannel$json = const {
  '1': 'ListFundsChannel',
  '2': const [
    const {'1': 'peer_id', '3': 1, '4': 1, '5': 12, '10': 'peerId'},
    const {'1': 'connected', '3': 2, '4': 1, '5': 8, '10': 'connected'},
    const {'1': 'short_channel_id', '3': 3, '4': 1, '5': 4, '10': 'shortChannelId'},
    const {'1': 'our_amount_msat', '3': 4, '4': 1, '5': 4, '10': 'ourAmountMsat'},
    const {'1': 'amount_msat', '3': 5, '4': 1, '5': 4, '10': 'amountMsat'},
    const {'1': 'funding_txid', '3': 6, '4': 1, '5': 12, '10': 'fundingTxid'},
    const {'1': 'funding_output', '3': 7, '4': 1, '5': 13, '10': 'fundingOutput'},
  ],
};

/// Descriptor for `ListFundsChannel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFundsChannelDescriptor = $convert.base64Decode('ChBMaXN0RnVuZHNDaGFubmVsEhcKB3BlZXJfaWQYASABKAxSBnBlZXJJZBIcCgljb25uZWN0ZWQYAiABKAhSCWNvbm5lY3RlZBIoChBzaG9ydF9jaGFubmVsX2lkGAMgASgEUg5zaG9ydENoYW5uZWxJZBImCg9vdXJfYW1vdW50X21zYXQYBCABKARSDW91ckFtb3VudE1zYXQSHwoLYW1vdW50X21zYXQYBSABKARSCmFtb3VudE1zYXQSIQoMZnVuZGluZ190eGlkGAYgASgMUgtmdW5kaW5nVHhpZBIlCg5mdW5kaW5nX291dHB1dBgHIAEoDVINZnVuZGluZ091dHB1dA==');
@$core.Deprecated('Use listFundsResponseDescriptor instead')
const ListFundsResponse$json = const {
  '1': 'ListFundsResponse',
  '2': const [
    const {'1': 'outputs', '3': 1, '4': 3, '5': 11, '6': '.greenlight.ListFundsOutput', '10': 'outputs'},
    const {'1': 'channels', '3': 2, '4': 3, '5': 11, '6': '.greenlight.ListFundsChannel', '10': 'channels'},
  ],
};

/// Descriptor for `ListFundsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFundsResponseDescriptor = $convert.base64Decode('ChFMaXN0RnVuZHNSZXNwb25zZRI1CgdvdXRwdXRzGAEgAygLMhsuZ3JlZW5saWdodC5MaXN0RnVuZHNPdXRwdXRSB291dHB1dHMSOAoIY2hhbm5lbHMYAiADKAsyHC5ncmVlbmxpZ2h0Lkxpc3RGdW5kc0NoYW5uZWxSCGNoYW5uZWxz');
@$core.Deprecated('Use feerateDescriptor instead')
const Feerate$json = const {
  '1': 'Feerate',
  '2': const [
    const {'1': 'preset', '3': 1, '4': 1, '5': 14, '6': '.greenlight.FeeratePreset', '9': 0, '10': 'preset'},
    const {'1': 'perkw', '3': 5, '4': 1, '5': 4, '9': 0, '10': 'perkw'},
    const {'1': 'perkb', '3': 6, '4': 1, '5': 4, '9': 0, '10': 'perkb'},
  ],
  '8': const [
    const {'1': 'value'},
  ],
};

/// Descriptor for `Feerate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feerateDescriptor = $convert.base64Decode('CgdGZWVyYXRlEjMKBnByZXNldBgBIAEoDjIZLmdyZWVubGlnaHQuRmVlcmF0ZVByZXNldEgAUgZwcmVzZXQSFgoFcGVya3cYBSABKARIAFIFcGVya3cSFgoFcGVya2IYBiABKARIAFIFcGVya2JCBwoFdmFsdWU=');
@$core.Deprecated('Use confirmationDescriptor instead')
const Confirmation$json = const {
  '1': 'Confirmation',
  '2': const [
    const {'1': 'blocks', '3': 1, '4': 1, '5': 13, '10': 'blocks'},
  ],
};

/// Descriptor for `Confirmation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmationDescriptor = $convert.base64Decode('CgxDb25maXJtYXRpb24SFgoGYmxvY2tzGAEgASgNUgZibG9ja3M=');
@$core.Deprecated('Use withdrawRequestDescriptor instead')
const WithdrawRequest$json = const {
  '1': 'WithdrawRequest',
  '2': const [
    const {'1': 'destination', '3': 1, '4': 1, '5': 9, '10': 'destination'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 11, '6': '.greenlight.Amount', '10': 'amount'},
    const {'1': 'feerate', '3': 3, '4': 1, '5': 11, '6': '.greenlight.Feerate', '10': 'feerate'},
    const {'1': 'minconf', '3': 7, '4': 1, '5': 11, '6': '.greenlight.Confirmation', '10': 'minconf'},
    const {'1': 'utxos', '3': 8, '4': 3, '5': 11, '6': '.greenlight.Outpoint', '10': 'utxos'},
  ],
};

/// Descriptor for `WithdrawRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawRequestDescriptor = $convert.base64Decode('Cg9XaXRoZHJhd1JlcXVlc3QSIAoLZGVzdGluYXRpb24YASABKAlSC2Rlc3RpbmF0aW9uEioKBmFtb3VudBgCIAEoCzISLmdyZWVubGlnaHQuQW1vdW50UgZhbW91bnQSLQoHZmVlcmF0ZRgDIAEoCzITLmdyZWVubGlnaHQuRmVlcmF0ZVIHZmVlcmF0ZRIyCgdtaW5jb25mGAcgASgLMhguZ3JlZW5saWdodC5Db25maXJtYXRpb25SB21pbmNvbmYSKgoFdXR4b3MYCCADKAsyFC5ncmVlbmxpZ2h0Lk91dHBvaW50UgV1dHhvcw==');
@$core.Deprecated('Use withdrawResponseDescriptor instead')
const WithdrawResponse$json = const {
  '1': 'WithdrawResponse',
  '2': const [
    const {'1': 'tx', '3': 1, '4': 1, '5': 12, '10': 'tx'},
    const {'1': 'txid', '3': 2, '4': 1, '5': 12, '10': 'txid'},
  ],
};

/// Descriptor for `WithdrawResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawResponseDescriptor = $convert.base64Decode('ChBXaXRoZHJhd1Jlc3BvbnNlEg4KAnR4GAEgASgMUgJ0eBISCgR0eGlkGAIgASgMUgR0eGlk');
@$core.Deprecated('Use fundChannelRequestDescriptor instead')
const FundChannelRequest$json = const {
  '1': 'FundChannelRequest',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 12, '10': 'nodeId'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 11, '6': '.greenlight.Amount', '10': 'amount'},
    const {'1': 'feerate', '3': 3, '4': 1, '5': 11, '6': '.greenlight.Feerate', '10': 'feerate'},
    const {'1': 'announce', '3': 7, '4': 1, '5': 8, '10': 'announce'},
    const {'1': 'minconf', '3': 8, '4': 1, '5': 11, '6': '.greenlight.Confirmation', '10': 'minconf'},
    const {'1': 'close_to', '3': 10, '4': 1, '5': 9, '10': 'closeTo'},
  ],
};

/// Descriptor for `FundChannelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fundChannelRequestDescriptor = $convert.base64Decode('ChJGdW5kQ2hhbm5lbFJlcXVlc3QSFwoHbm9kZV9pZBgBIAEoDFIGbm9kZUlkEioKBmFtb3VudBgCIAEoCzISLmdyZWVubGlnaHQuQW1vdW50UgZhbW91bnQSLQoHZmVlcmF0ZRgDIAEoCzITLmdyZWVubGlnaHQuRmVlcmF0ZVIHZmVlcmF0ZRIaCghhbm5vdW5jZRgHIAEoCFIIYW5ub3VuY2USMgoHbWluY29uZhgIIAEoCzIYLmdyZWVubGlnaHQuQ29uZmlybWF0aW9uUgdtaW5jb25mEhkKCGNsb3NlX3RvGAogASgJUgdjbG9zZVRv');
@$core.Deprecated('Use outpointDescriptor instead')
const Outpoint$json = const {
  '1': 'Outpoint',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 1, '5': 12, '10': 'txid'},
    const {'1': 'outnum', '3': 2, '4': 1, '5': 13, '10': 'outnum'},
  ],
};

/// Descriptor for `Outpoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List outpointDescriptor = $convert.base64Decode('CghPdXRwb2ludBISCgR0eGlkGAEgASgMUgR0eGlkEhYKBm91dG51bRgCIAEoDVIGb3V0bnVt');
@$core.Deprecated('Use fundChannelResponseDescriptor instead')
const FundChannelResponse$json = const {
  '1': 'FundChannelResponse',
  '2': const [
    const {'1': 'tx', '3': 1, '4': 1, '5': 12, '10': 'tx'},
    const {'1': 'outpoint', '3': 2, '4': 1, '5': 11, '6': '.greenlight.Outpoint', '10': 'outpoint'},
    const {'1': 'channel_id', '3': 3, '4': 1, '5': 12, '10': 'channelId'},
    const {'1': 'close_to', '3': 4, '4': 1, '5': 9, '10': 'closeTo'},
  ],
};

/// Descriptor for `FundChannelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fundChannelResponseDescriptor = $convert.base64Decode('ChNGdW5kQ2hhbm5lbFJlc3BvbnNlEg4KAnR4GAEgASgMUgJ0eBIwCghvdXRwb2ludBgCIAEoCzIULmdyZWVubGlnaHQuT3V0cG9pbnRSCG91dHBvaW50Eh0KCmNoYW5uZWxfaWQYAyABKAxSCWNoYW5uZWxJZBIZCghjbG9zZV90bxgEIAEoCVIHY2xvc2VUbw==');
@$core.Deprecated('Use timeoutDescriptor instead')
const Timeout$json = const {
  '1': 'Timeout',
  '2': const [
    const {'1': 'seconds', '3': 1, '4': 1, '5': 13, '10': 'seconds'},
  ],
};

/// Descriptor for `Timeout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeoutDescriptor = $convert.base64Decode('CgdUaW1lb3V0EhgKB3NlY29uZHMYASABKA1SB3NlY29uZHM=');
@$core.Deprecated('Use bitcoinAddressDescriptor instead')
const BitcoinAddress$json = const {
  '1': 'BitcoinAddress',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `BitcoinAddress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bitcoinAddressDescriptor = $convert.base64Decode('Cg5CaXRjb2luQWRkcmVzcxIYCgdhZGRyZXNzGAEgASgJUgdhZGRyZXNz');
@$core.Deprecated('Use closeChannelRequestDescriptor instead')
const CloseChannelRequest$json = const {
  '1': 'CloseChannelRequest',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 12, '10': 'nodeId'},
    const {'1': 'unilateraltimeout', '3': 2, '4': 1, '5': 11, '6': '.greenlight.Timeout', '10': 'unilateraltimeout'},
    const {'1': 'destination', '3': 3, '4': 1, '5': 11, '6': '.greenlight.BitcoinAddress', '10': 'destination'},
  ],
};

/// Descriptor for `CloseChannelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeChannelRequestDescriptor = $convert.base64Decode('ChNDbG9zZUNoYW5uZWxSZXF1ZXN0EhcKB25vZGVfaWQYASABKAxSBm5vZGVJZBJBChF1bmlsYXRlcmFsdGltZW91dBgCIAEoCzITLmdyZWVubGlnaHQuVGltZW91dFIRdW5pbGF0ZXJhbHRpbWVvdXQSPAoLZGVzdGluYXRpb24YAyABKAsyGi5ncmVlbmxpZ2h0LkJpdGNvaW5BZGRyZXNzUgtkZXN0aW5hdGlvbg==');
@$core.Deprecated('Use closeChannelResponseDescriptor instead')
const CloseChannelResponse$json = const {
  '1': 'CloseChannelResponse',
  '2': const [
    const {'1': 'close_type', '3': 1, '4': 1, '5': 14, '6': '.greenlight.CloseChannelType', '10': 'closeType'},
    const {'1': 'tx', '3': 2, '4': 1, '5': 12, '10': 'tx'},
    const {'1': 'txid', '3': 3, '4': 1, '5': 12, '10': 'txid'},
  ],
};

/// Descriptor for `CloseChannelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeChannelResponseDescriptor = $convert.base64Decode('ChRDbG9zZUNoYW5uZWxSZXNwb25zZRI7CgpjbG9zZV90eXBlGAEgASgOMhwuZ3JlZW5saWdodC5DbG9zZUNoYW5uZWxUeXBlUgljbG9zZVR5cGUSDgoCdHgYAiABKAxSAnR4EhIKBHR4aWQYAyABKAxSBHR4aWQ=');
@$core.Deprecated('Use amountDescriptor instead')
const Amount$json = const {
  '1': 'Amount',
  '2': const [
    const {'1': 'millisatoshi', '3': 1, '4': 1, '5': 4, '9': 0, '10': 'millisatoshi'},
    const {'1': 'satoshi', '3': 2, '4': 1, '5': 4, '9': 0, '10': 'satoshi'},
    const {'1': 'bitcoin', '3': 3, '4': 1, '5': 4, '9': 0, '10': 'bitcoin'},
    const {'1': 'all', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'all'},
    const {'1': 'any', '3': 5, '4': 1, '5': 8, '9': 0, '10': 'any'},
  ],
  '8': const [
    const {'1': 'unit'},
  ],
};

/// Descriptor for `Amount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List amountDescriptor = $convert.base64Decode('CgZBbW91bnQSJAoMbWlsbGlzYXRvc2hpGAEgASgESABSDG1pbGxpc2F0b3NoaRIaCgdzYXRvc2hpGAIgASgESABSB3NhdG9zaGkSGgoHYml0Y29pbhgDIAEoBEgAUgdiaXRjb2luEhIKA2FsbBgEIAEoCEgAUgNhbGwSEgoDYW55GAUgASgISABSA2FueUIGCgR1bml0');
@$core.Deprecated('Use invoiceRequestDescriptor instead')
const InvoiceRequest$json = const {
  '1': 'InvoiceRequest',
  '2': const [
    const {'1': 'amount', '3': 1, '4': 1, '5': 11, '6': '.greenlight.Amount', '10': 'amount'},
    const {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `InvoiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceRequestDescriptor = $convert.base64Decode('Cg5JbnZvaWNlUmVxdWVzdBIqCgZhbW91bnQYASABKAsyEi5ncmVlbmxpZ2h0LkFtb3VudFIGYW1vdW50EhQKBWxhYmVsGAIgASgJUgVsYWJlbBIgCgtkZXNjcmlwdGlvbhgDIAEoCVILZGVzY3JpcHRpb24=');
@$core.Deprecated('Use invoiceDescriptor instead')
const Invoice$json = const {
  '1': 'Invoice',
  '2': const [
    const {'1': 'label', '3': 1, '4': 1, '5': 9, '10': 'label'},
    const {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'amount', '3': 3, '4': 1, '5': 11, '6': '.greenlight.Amount', '10': 'amount'},
    const {'1': 'received', '3': 4, '4': 1, '5': 11, '6': '.greenlight.Amount', '10': 'received'},
    const {'1': 'status', '3': 5, '4': 1, '5': 14, '6': '.greenlight.InvoiceStatus', '10': 'status'},
    const {'1': 'payment_time', '3': 6, '4': 1, '5': 13, '10': 'paymentTime'},
    const {'1': 'expiry_time', '3': 7, '4': 1, '5': 13, '10': 'expiryTime'},
    const {'1': 'bolt11', '3': 8, '4': 1, '5': 9, '10': 'bolt11'},
    const {'1': 'payment_hash', '3': 9, '4': 1, '5': 12, '10': 'paymentHash'},
    const {'1': 'payment_preimage', '3': 10, '4': 1, '5': 12, '10': 'paymentPreimage'},
  ],
};

/// Descriptor for `Invoice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceDescriptor = $convert.base64Decode('CgdJbnZvaWNlEhQKBWxhYmVsGAEgASgJUgVsYWJlbBIgCgtkZXNjcmlwdGlvbhgCIAEoCVILZGVzY3JpcHRpb24SKgoGYW1vdW50GAMgASgLMhIuZ3JlZW5saWdodC5BbW91bnRSBmFtb3VudBIuCghyZWNlaXZlZBgEIAEoCzISLmdyZWVubGlnaHQuQW1vdW50UghyZWNlaXZlZBIxCgZzdGF0dXMYBSABKA4yGS5ncmVlbmxpZ2h0Lkludm9pY2VTdGF0dXNSBnN0YXR1cxIhCgxwYXltZW50X3RpbWUYBiABKA1SC3BheW1lbnRUaW1lEh8KC2V4cGlyeV90aW1lGAcgASgNUgpleHBpcnlUaW1lEhYKBmJvbHQxMRgIIAEoCVIGYm9sdDExEiEKDHBheW1lbnRfaGFzaBgJIAEoDFILcGF5bWVudEhhc2gSKQoQcGF5bWVudF9wcmVpbWFnZRgKIAEoDFIPcGF5bWVudFByZWltYWdl');
@$core.Deprecated('Use payRequestDescriptor instead')
const PayRequest$json = const {
  '1': 'PayRequest',
  '2': const [
    const {'1': 'bolt11', '3': 1, '4': 1, '5': 9, '10': 'bolt11'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 11, '6': '.greenlight.Amount', '10': 'amount'},
    const {'1': 'timeout', '3': 3, '4': 1, '5': 13, '10': 'timeout'},
  ],
};

/// Descriptor for `PayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List payRequestDescriptor = $convert.base64Decode('CgpQYXlSZXF1ZXN0EhYKBmJvbHQxMRgBIAEoCVIGYm9sdDExEioKBmFtb3VudBgCIAEoCzISLmdyZWVubGlnaHQuQW1vdW50UgZhbW91bnQSGAoHdGltZW91dBgDIAEoDVIHdGltZW91dA==');
@$core.Deprecated('Use paymentDescriptor instead')
const Payment$json = const {
  '1': 'Payment',
  '2': const [
    const {'1': 'destination', '3': 1, '4': 1, '5': 12, '10': 'destination'},
    const {'1': 'payment_hash', '3': 2, '4': 1, '5': 12, '10': 'paymentHash'},
    const {'1': 'payment_preimage', '3': 3, '4': 1, '5': 12, '10': 'paymentPreimage'},
    const {'1': 'status', '3': 4, '4': 1, '5': 14, '6': '.greenlight.PayStatus', '10': 'status'},
    const {'1': 'amount', '3': 5, '4': 1, '5': 11, '6': '.greenlight.Amount', '10': 'amount'},
    const {'1': 'amount_sent', '3': 6, '4': 1, '5': 11, '6': '.greenlight.Amount', '10': 'amountSent'},
    const {'1': 'bolt11', '3': 7, '4': 1, '5': 9, '10': 'bolt11'},
    const {'1': 'created_at', '3': 8, '4': 1, '5': 1, '10': 'createdAt'},
  ],
};

/// Descriptor for `Payment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentDescriptor = $convert.base64Decode('CgdQYXltZW50EiAKC2Rlc3RpbmF0aW9uGAEgASgMUgtkZXN0aW5hdGlvbhIhCgxwYXltZW50X2hhc2gYAiABKAxSC3BheW1lbnRIYXNoEikKEHBheW1lbnRfcHJlaW1hZ2UYAyABKAxSD3BheW1lbnRQcmVpbWFnZRItCgZzdGF0dXMYBCABKA4yFS5ncmVlbmxpZ2h0LlBheVN0YXR1c1IGc3RhdHVzEioKBmFtb3VudBgFIAEoCzISLmdyZWVubGlnaHQuQW1vdW50UgZhbW91bnQSMwoLYW1vdW50X3NlbnQYBiABKAsyEi5ncmVlbmxpZ2h0LkFtb3VudFIKYW1vdW50U2VudBIWCgZib2x0MTEYByABKAlSBmJvbHQxMRIdCgpjcmVhdGVkX2F0GAggASgBUgljcmVhdGVkQXQ=');
@$core.Deprecated('Use paymentIdentifierDescriptor instead')
const PaymentIdentifier$json = const {
  '1': 'PaymentIdentifier',
  '2': const [
    const {'1': 'bolt11', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'bolt11'},
    const {'1': 'payment_hash', '3': 2, '4': 1, '5': 12, '9': 0, '10': 'paymentHash'},
  ],
  '8': const [
    const {'1': 'id'},
  ],
};

/// Descriptor for `PaymentIdentifier`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentIdentifierDescriptor = $convert.base64Decode('ChFQYXltZW50SWRlbnRpZmllchIYCgZib2x0MTEYASABKAlIAFIGYm9sdDExEiMKDHBheW1lbnRfaGFzaBgCIAEoDEgAUgtwYXltZW50SGFzaEIECgJpZA==');
@$core.Deprecated('Use listPaymentsRequestDescriptor instead')
const ListPaymentsRequest$json = const {
  '1': 'ListPaymentsRequest',
  '2': const [
    const {'1': 'identifier', '3': 1, '4': 1, '5': 11, '6': '.greenlight.PaymentIdentifier', '10': 'identifier'},
  ],
};

/// Descriptor for `ListPaymentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPaymentsRequestDescriptor = $convert.base64Decode('ChNMaXN0UGF5bWVudHNSZXF1ZXN0Ej0KCmlkZW50aWZpZXIYASABKAsyHS5ncmVlbmxpZ2h0LlBheW1lbnRJZGVudGlmaWVyUgppZGVudGlmaWVy');
@$core.Deprecated('Use listPaymentsResponseDescriptor instead')
const ListPaymentsResponse$json = const {
  '1': 'ListPaymentsResponse',
  '2': const [
    const {'1': 'payments', '3': 1, '4': 3, '5': 11, '6': '.greenlight.Payment', '10': 'payments'},
  ],
};

/// Descriptor for `ListPaymentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPaymentsResponseDescriptor = $convert.base64Decode('ChRMaXN0UGF5bWVudHNSZXNwb25zZRIvCghwYXltZW50cxgBIAMoCzITLmdyZWVubGlnaHQuUGF5bWVudFIIcGF5bWVudHM=');
@$core.Deprecated('Use invoiceIdentifierDescriptor instead')
const InvoiceIdentifier$json = const {
  '1': 'InvoiceIdentifier',
  '2': const [
    const {'1': 'label', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'label'},
    const {'1': 'invstring', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'invstring'},
    const {'1': 'payment_hash', '3': 3, '4': 1, '5': 12, '9': 0, '10': 'paymentHash'},
  ],
  '8': const [
    const {'1': 'id'},
  ],
};

/// Descriptor for `InvoiceIdentifier`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceIdentifierDescriptor = $convert.base64Decode('ChFJbnZvaWNlSWRlbnRpZmllchIWCgVsYWJlbBgBIAEoCUgAUgVsYWJlbBIeCglpbnZzdHJpbmcYAiABKAlIAFIJaW52c3RyaW5nEiMKDHBheW1lbnRfaGFzaBgDIAEoDEgAUgtwYXltZW50SGFzaEIECgJpZA==');
@$core.Deprecated('Use listInvoicesRequestDescriptor instead')
const ListInvoicesRequest$json = const {
  '1': 'ListInvoicesRequest',
  '2': const [
    const {'1': 'identifier', '3': 1, '4': 1, '5': 11, '6': '.greenlight.InvoiceIdentifier', '10': 'identifier'},
  ],
};

/// Descriptor for `ListInvoicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInvoicesRequestDescriptor = $convert.base64Decode('ChNMaXN0SW52b2ljZXNSZXF1ZXN0Ej0KCmlkZW50aWZpZXIYASABKAsyHS5ncmVlbmxpZ2h0Lkludm9pY2VJZGVudGlmaWVyUgppZGVudGlmaWVy');
@$core.Deprecated('Use streamIncomingFilterDescriptor instead')
const StreamIncomingFilter$json = const {
  '1': 'StreamIncomingFilter',
};

/// Descriptor for `StreamIncomingFilter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamIncomingFilterDescriptor = $convert.base64Decode('ChRTdHJlYW1JbmNvbWluZ0ZpbHRlcg==');
@$core.Deprecated('Use listInvoicesResponseDescriptor instead')
const ListInvoicesResponse$json = const {
  '1': 'ListInvoicesResponse',
  '2': const [
    const {'1': 'invoices', '3': 1, '4': 3, '5': 11, '6': '.greenlight.Invoice', '10': 'invoices'},
  ],
};

/// Descriptor for `ListInvoicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInvoicesResponseDescriptor = $convert.base64Decode('ChRMaXN0SW52b2ljZXNSZXNwb25zZRIvCghpbnZvaWNlcxgBIAMoCzITLmdyZWVubGlnaHQuSW52b2ljZVIIaW52b2ljZXM=');
@$core.Deprecated('Use tlvFieldDescriptor instead')
const TlvField$json = const {
  '1': 'TlvField',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 4, '10': 'type'},
    const {'1': 'value', '3': 2, '4': 1, '5': 12, '10': 'value'},
  ],
};

/// Descriptor for `TlvField`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tlvFieldDescriptor = $convert.base64Decode('CghUbHZGaWVsZBISCgR0eXBlGAEgASgEUgR0eXBlEhQKBXZhbHVlGAIgASgMUgV2YWx1ZQ==');
@$core.Deprecated('Use offChainPaymentDescriptor instead')
const OffChainPayment$json = const {
  '1': 'OffChainPayment',
  '2': const [
    const {'1': 'label', '3': 1, '4': 1, '5': 9, '10': 'label'},
    const {'1': 'preimage', '3': 2, '4': 1, '5': 12, '10': 'preimage'},
    const {'1': 'amount', '3': 3, '4': 1, '5': 11, '6': '.greenlight.Amount', '10': 'amount'},
    const {'1': 'extratlvs', '3': 4, '4': 3, '5': 11, '6': '.greenlight.TlvField', '10': 'extratlvs'},
    const {'1': 'payment_hash', '3': 5, '4': 1, '5': 12, '10': 'paymentHash'},
    const {'1': 'bolt11', '3': 6, '4': 1, '5': 9, '10': 'bolt11'},
  ],
};

/// Descriptor for `OffChainPayment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offChainPaymentDescriptor = $convert.base64Decode('Cg9PZmZDaGFpblBheW1lbnQSFAoFbGFiZWwYASABKAlSBWxhYmVsEhoKCHByZWltYWdlGAIgASgMUghwcmVpbWFnZRIqCgZhbW91bnQYAyABKAsyEi5ncmVlbmxpZ2h0LkFtb3VudFIGYW1vdW50EjIKCWV4dHJhdGx2cxgEIAMoCzIULmdyZWVubGlnaHQuVGx2RmllbGRSCWV4dHJhdGx2cxIhCgxwYXltZW50X2hhc2gYBSABKAxSC3BheW1lbnRIYXNoEhYKBmJvbHQxMRgGIAEoCVIGYm9sdDEx');
@$core.Deprecated('Use incomingPaymentDescriptor instead')
const IncomingPayment$json = const {
  '1': 'IncomingPayment',
  '2': const [
    const {'1': 'offchain', '3': 1, '4': 1, '5': 11, '6': '.greenlight.OffChainPayment', '9': 0, '10': 'offchain'},
  ],
  '8': const [
    const {'1': 'details'},
  ],
};

/// Descriptor for `IncomingPayment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List incomingPaymentDescriptor = $convert.base64Decode('Cg9JbmNvbWluZ1BheW1lbnQSOQoIb2ZmY2hhaW4YASABKAsyGy5ncmVlbmxpZ2h0Lk9mZkNoYWluUGF5bWVudEgAUghvZmZjaGFpbkIJCgdkZXRhaWxz');
@$core.Deprecated('Use routehintHopDescriptor instead')
const RoutehintHop$json = const {
  '1': 'RoutehintHop',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 12, '10': 'nodeId'},
    const {'1': 'short_channel_id', '3': 2, '4': 1, '5': 9, '10': 'shortChannelId'},
    const {'1': 'fee_base', '3': 3, '4': 1, '5': 4, '10': 'feeBase'},
    const {'1': 'fee_prop', '3': 4, '4': 1, '5': 13, '10': 'feeProp'},
    const {'1': 'cltv_expiry_delta', '3': 5, '4': 1, '5': 13, '10': 'cltvExpiryDelta'},
  ],
};

/// Descriptor for `RoutehintHop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List routehintHopDescriptor = $convert.base64Decode('CgxSb3V0ZWhpbnRIb3ASFwoHbm9kZV9pZBgBIAEoDFIGbm9kZUlkEigKEHNob3J0X2NoYW5uZWxfaWQYAiABKAlSDnNob3J0Q2hhbm5lbElkEhkKCGZlZV9iYXNlGAMgASgEUgdmZWVCYXNlEhkKCGZlZV9wcm9wGAQgASgNUgdmZWVQcm9wEioKEWNsdHZfZXhwaXJ5X2RlbHRhGAUgASgNUg9jbHR2RXhwaXJ5RGVsdGE=');
@$core.Deprecated('Use routehintDescriptor instead')
const Routehint$json = const {
  '1': 'Routehint',
  '2': const [
    const {'1': 'hops', '3': 1, '4': 3, '5': 11, '6': '.greenlight.RoutehintHop', '10': 'hops'},
  ],
};

/// Descriptor for `Routehint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List routehintDescriptor = $convert.base64Decode('CglSb3V0ZWhpbnQSLAoEaG9wcxgBIAMoCzIYLmdyZWVubGlnaHQuUm91dGVoaW50SG9wUgRob3Bz');
@$core.Deprecated('Use keysendRequestDescriptor instead')
const KeysendRequest$json = const {
  '1': 'KeysendRequest',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 12, '10': 'nodeId'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 11, '6': '.greenlight.Amount', '10': 'amount'},
    const {'1': 'label', '3': 3, '4': 1, '5': 9, '10': 'label'},
    const {'1': 'routehints', '3': 4, '4': 3, '5': 11, '6': '.greenlight.Routehint', '10': 'routehints'},
    const {'1': 'extratlvs', '3': 5, '4': 3, '5': 11, '6': '.greenlight.TlvField', '10': 'extratlvs'},
  ],
};

/// Descriptor for `KeysendRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List keysendRequestDescriptor = $convert.base64Decode('Cg5LZXlzZW5kUmVxdWVzdBIXCgdub2RlX2lkGAEgASgMUgZub2RlSWQSKgoGYW1vdW50GAIgASgLMhIuZ3JlZW5saWdodC5BbW91bnRSBmFtb3VudBIUCgVsYWJlbBgDIAEoCVIFbGFiZWwSNQoKcm91dGVoaW50cxgEIAMoCzIVLmdyZWVubGlnaHQuUm91dGVoaW50Ugpyb3V0ZWhpbnRzEjIKCWV4dHJhdGx2cxgFIAMoCzIULmdyZWVubGlnaHQuVGx2RmllbGRSCWV4dHJhdGx2cw==');
@$core.Deprecated('Use streamLogRequestDescriptor instead')
const StreamLogRequest$json = const {
  '1': 'StreamLogRequest',
};

/// Descriptor for `StreamLogRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamLogRequestDescriptor = $convert.base64Decode('ChBTdHJlYW1Mb2dSZXF1ZXN0');
@$core.Deprecated('Use logEntryDescriptor instead')
const LogEntry$json = const {
  '1': 'LogEntry',
  '2': const [
    const {'1': 'line', '3': 1, '4': 1, '5': 9, '10': 'line'},
  ],
};

/// Descriptor for `LogEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logEntryDescriptor = $convert.base64Decode('CghMb2dFbnRyeRISCgRsaW5lGAEgASgJUgRsaW5l');
