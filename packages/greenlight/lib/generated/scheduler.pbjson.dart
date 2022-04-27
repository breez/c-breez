///
//  Generated code. Do not modify.
//  source: scheduler.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use challengeScopeDescriptor instead')
const ChallengeScope$json = const {
  '1': 'ChallengeScope',
  '2': const [
    const {'1': 'REGISTER', '2': 0},
    const {'1': 'RECOVER', '2': 1},
  ],
};

/// Descriptor for `ChallengeScope`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List challengeScopeDescriptor = $convert.base64Decode(
    'Cg5DaGFsbGVuZ2VTY29wZRIMCghSRUdJU1RFUhAAEgsKB1JFQ09WRVIQAQ==');
@$core.Deprecated('Use challengeRequestDescriptor instead')
const ChallengeRequest$json = const {
  '1': 'ChallengeRequest',
  '2': const [
    const {
      '1': 'scope',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.scheduler.ChallengeScope',
      '10': 'scope'
    },
    const {'1': 'node_id', '3': 2, '4': 1, '5': 12, '10': 'nodeId'},
  ],
};

/// Descriptor for `ChallengeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List challengeRequestDescriptor = $convert.base64Decode(
    'ChBDaGFsbGVuZ2VSZXF1ZXN0Ei8KBXNjb3BlGAEgASgOMhkuc2NoZWR1bGVyLkNoYWxsZW5nZVNjb3BlUgVzY29wZRIXCgdub2RlX2lkGAIgASgMUgZub2RlSWQ=');
@$core.Deprecated('Use challengeResponseDescriptor instead')
const ChallengeResponse$json = const {
  '1': 'ChallengeResponse',
  '2': const [
    const {'1': 'challenge', '3': 1, '4': 1, '5': 12, '10': 'challenge'},
  ],
};

/// Descriptor for `ChallengeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List challengeResponseDescriptor = $convert.base64Decode(
    'ChFDaGFsbGVuZ2VSZXNwb25zZRIcCgljaGFsbGVuZ2UYASABKAxSCWNoYWxsZW5nZQ==');
@$core.Deprecated('Use registrationRequestDescriptor instead')
const RegistrationRequest$json = const {
  '1': 'RegistrationRequest',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 12, '10': 'nodeId'},
    const {'1': 'bip32_key', '3': 2, '4': 1, '5': 12, '10': 'bip32Key'},
    const {'1': 'network', '3': 4, '4': 1, '5': 9, '10': 'network'},
    const {'1': 'challenge', '3': 5, '4': 1, '5': 12, '10': 'challenge'},
    const {'1': 'signature', '3': 6, '4': 1, '5': 12, '10': 'signature'},
    const {'1': 'signer_proto', '3': 7, '4': 1, '5': 9, '10': 'signerProto'},
    const {
      '1': 'init_msg',
      '3': 8,
      '4': 1,
      '5': 12,
      '9': 0,
      '10': 'initMsg',
      '17': true
    },
  ],
  '8': const [
    const {'1': '_init_msg'},
  ],
};

/// Descriptor for `RegistrationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registrationRequestDescriptor = $convert.base64Decode(
    'ChNSZWdpc3RyYXRpb25SZXF1ZXN0EhcKB25vZGVfaWQYASABKAxSBm5vZGVJZBIbCgliaXAzMl9rZXkYAiABKAxSCGJpcDMyS2V5EhgKB25ldHdvcmsYBCABKAlSB25ldHdvcmsSHAoJY2hhbGxlbmdlGAUgASgMUgljaGFsbGVuZ2USHAoJc2lnbmF0dXJlGAYgASgMUglzaWduYXR1cmUSIQoMc2lnbmVyX3Byb3RvGAcgASgJUgtzaWduZXJQcm90bxIeCghpbml0X21zZxgIIAEoDEgAUgdpbml0TXNniAEBQgsKCV9pbml0X21zZw==');
@$core.Deprecated('Use registrationResponseDescriptor instead')
const RegistrationResponse$json = const {
  '1': 'RegistrationResponse',
  '2': const [
    const {'1': 'device_cert', '3': 1, '4': 1, '5': 9, '10': 'deviceCert'},
    const {'1': 'device_key', '3': 2, '4': 1, '5': 9, '10': 'deviceKey'},
  ],
};

/// Descriptor for `RegistrationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registrationResponseDescriptor = $convert.base64Decode(
    'ChRSZWdpc3RyYXRpb25SZXNwb25zZRIfCgtkZXZpY2VfY2VydBgBIAEoCVIKZGV2aWNlQ2VydBIdCgpkZXZpY2Vfa2V5GAIgASgJUglkZXZpY2VLZXk=');
@$core.Deprecated('Use scheduleRequestDescriptor instead')
const ScheduleRequest$json = const {
  '1': 'ScheduleRequest',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 12, '10': 'nodeId'},
  ],
};

/// Descriptor for `ScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleRequestDescriptor = $convert
    .base64Decode('Cg9TY2hlZHVsZVJlcXVlc3QSFwoHbm9kZV9pZBgBIAEoDFIGbm9kZUlk');
@$core.Deprecated('Use nodeInfoRequestDescriptor instead')
const NodeInfoRequest$json = const {
  '1': 'NodeInfoRequest',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 12, '10': 'nodeId'},
    const {'1': 'wait', '3': 2, '4': 1, '5': 8, '10': 'wait'},
  ],
};

/// Descriptor for `NodeInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nodeInfoRequestDescriptor = $convert.base64Decode(
    'Cg9Ob2RlSW5mb1JlcXVlc3QSFwoHbm9kZV9pZBgBIAEoDFIGbm9kZUlkEhIKBHdhaXQYAiABKAhSBHdhaXQ=');
@$core.Deprecated('Use nodeInfoResponseDescriptor instead')
const NodeInfoResponse$json = const {
  '1': 'NodeInfoResponse',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 12, '10': 'nodeId'},
    const {'1': 'grpc_uri', '3': 2, '4': 1, '5': 9, '10': 'grpcUri'},
  ],
};

/// Descriptor for `NodeInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nodeInfoResponseDescriptor = $convert.base64Decode(
    'ChBOb2RlSW5mb1Jlc3BvbnNlEhcKB25vZGVfaWQYASABKAxSBm5vZGVJZBIZCghncnBjX3VyaRgCIAEoCVIHZ3JwY1VyaQ==');
@$core.Deprecated('Use recoveryRequestDescriptor instead')
const RecoveryRequest$json = const {
  '1': 'RecoveryRequest',
  '2': const [
    const {'1': 'challenge', '3': 1, '4': 1, '5': 12, '10': 'challenge'},
    const {'1': 'signature', '3': 2, '4': 1, '5': 12, '10': 'signature'},
    const {'1': 'node_id', '3': 3, '4': 1, '5': 12, '10': 'nodeId'},
  ],
};

/// Descriptor for `RecoveryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recoveryRequestDescriptor = $convert.base64Decode(
    'Cg9SZWNvdmVyeVJlcXVlc3QSHAoJY2hhbGxlbmdlGAEgASgMUgljaGFsbGVuZ2USHAoJc2lnbmF0dXJlGAIgASgMUglzaWduYXR1cmUSFwoHbm9kZV9pZBgDIAEoDFIGbm9kZUlk');
@$core.Deprecated('Use recoveryResponseDescriptor instead')
const RecoveryResponse$json = const {
  '1': 'RecoveryResponse',
  '2': const [
    const {'1': 'device_cert', '3': 1, '4': 1, '5': 9, '10': 'deviceCert'},
    const {'1': 'device_key', '3': 2, '4': 1, '5': 9, '10': 'deviceKey'},
  ],
};

/// Descriptor for `RecoveryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recoveryResponseDescriptor = $convert.base64Decode(
    'ChBSZWNvdmVyeVJlc3BvbnNlEh8KC2RldmljZV9jZXJ0GAEgASgJUgpkZXZpY2VDZXJ0Eh0KCmRldmljZV9rZXkYAiABKAlSCWRldmljZUtleQ==');
@$core.Deprecated('Use upgradeRequestDescriptor instead')
const UpgradeRequest$json = const {
  '1': 'UpgradeRequest',
  '2': const [
    const {
      '1': 'signer_version',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'signerVersion'
    },
    const {'1': 'initmsg', '3': 2, '4': 1, '5': 12, '10': 'initmsg'},
  ],
};

/// Descriptor for `UpgradeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upgradeRequestDescriptor = $convert.base64Decode(
    'Cg5VcGdyYWRlUmVxdWVzdBIlCg5zaWduZXJfdmVyc2lvbhgBIAEoCVINc2lnbmVyVmVyc2lvbhIYCgdpbml0bXNnGAIgASgMUgdpbml0bXNn');
@$core.Deprecated('Use upgradeResponseDescriptor instead')
const UpgradeResponse$json = const {
  '1': 'UpgradeResponse',
  '2': const [
    const {'1': 'old_version', '3': 1, '4': 1, '5': 9, '10': 'oldVersion'},
  ],
};

/// Descriptor for `UpgradeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upgradeResponseDescriptor = $convert.base64Decode(
    'Cg9VcGdyYWRlUmVzcG9uc2USHwoLb2xkX3ZlcnNpb24YASABKAlSCm9sZFZlcnNpb24=');
