///
//  Generated code. Do not modify.
//  source: scheduler.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'scheduler.pbenum.dart';

export 'scheduler.pbenum.dart';

class ChallengeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChallengeRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'scheduler'), createEmptyInstance: create)
    ..e<ChallengeScope>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scope', $pb.PbFieldType.OE, defaultOrMaker: ChallengeScope.REGISTER, valueOf: ChallengeScope.valueOf, enumValues: ChallengeScope.values)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeId', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ChallengeRequest._() : super();
  factory ChallengeRequest({
    ChallengeScope? scope,
    $core.List<$core.int>? nodeId,
  }) {
    final _result = create();
    if (scope != null) {
      _result.scope = scope;
    }
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    return _result;
  }
  factory ChallengeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChallengeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChallengeRequest clone() => ChallengeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChallengeRequest copyWith(void Function(ChallengeRequest) updates) => super.copyWith((message) => updates(message as ChallengeRequest)) as ChallengeRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ChallengeRequest create() => ChallengeRequest._();
  ChallengeRequest createEmptyInstance() => create();
  static $pb.PbList<ChallengeRequest> createRepeated() => $pb.PbList<ChallengeRequest>();
  @$core.pragma('dart2js:noInline')
  static ChallengeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChallengeRequest>(create);
  static ChallengeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ChallengeScope get scope => $_getN(0);
  @$pb.TagNumber(1)
  set scope(ChallengeScope v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasScope() => $_has(0);
  @$pb.TagNumber(1)
  void clearScope() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get nodeId => $_getN(1);
  @$pb.TagNumber(2)
  set nodeId($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNodeId() => clearField(2);
}

class ChallengeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChallengeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'scheduler'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'challenge', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ChallengeResponse._() : super();
  factory ChallengeResponse({
    $core.List<$core.int>? challenge,
  }) {
    final _result = create();
    if (challenge != null) {
      _result.challenge = challenge;
    }
    return _result;
  }
  factory ChallengeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChallengeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChallengeResponse clone() => ChallengeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChallengeResponse copyWith(void Function(ChallengeResponse) updates) => super.copyWith((message) => updates(message as ChallengeResponse)) as ChallengeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ChallengeResponse create() => ChallengeResponse._();
  ChallengeResponse createEmptyInstance() => create();
  static $pb.PbList<ChallengeResponse> createRepeated() => $pb.PbList<ChallengeResponse>();
  @$core.pragma('dart2js:noInline')
  static ChallengeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChallengeResponse>(create);
  static ChallengeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get challenge => $_getN(0);
  @$pb.TagNumber(1)
  set challenge($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChallenge() => $_has(0);
  @$pb.TagNumber(1)
  void clearChallenge() => clearField(1);
}

class RegistrationRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RegistrationRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'scheduler'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeId', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bip32Key', $pb.PbFieldType.OY)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'network')
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'challenge', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signature', $pb.PbFieldType.OY)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signerProto')
    ..a<$core.List<$core.int>>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'initMsg', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  RegistrationRequest._() : super();
  factory RegistrationRequest({
    $core.List<$core.int>? nodeId,
    $core.List<$core.int>? bip32Key,
    $core.String? network,
    $core.List<$core.int>? challenge,
    $core.List<$core.int>? signature,
    $core.String? signerProto,
    $core.List<$core.int>? initMsg,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (bip32Key != null) {
      _result.bip32Key = bip32Key;
    }
    if (network != null) {
      _result.network = network;
    }
    if (challenge != null) {
      _result.challenge = challenge;
    }
    if (signature != null) {
      _result.signature = signature;
    }
    if (signerProto != null) {
      _result.signerProto = signerProto;
    }
    if (initMsg != null) {
      _result.initMsg = initMsg;
    }
    return _result;
  }
  factory RegistrationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegistrationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegistrationRequest clone() => RegistrationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegistrationRequest copyWith(void Function(RegistrationRequest) updates) => super.copyWith((message) => updates(message as RegistrationRequest)) as RegistrationRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RegistrationRequest create() => RegistrationRequest._();
  RegistrationRequest createEmptyInstance() => create();
  static $pb.PbList<RegistrationRequest> createRepeated() => $pb.PbList<RegistrationRequest>();
  @$core.pragma('dart2js:noInline')
  static RegistrationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegistrationRequest>(create);
  static RegistrationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get nodeId => $_getN(0);
  @$pb.TagNumber(1)
  set nodeId($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get bip32Key => $_getN(1);
  @$pb.TagNumber(2)
  set bip32Key($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBip32Key() => $_has(1);
  @$pb.TagNumber(2)
  void clearBip32Key() => clearField(2);

  @$pb.TagNumber(4)
  $core.String get network => $_getSZ(2);
  @$pb.TagNumber(4)
  set network($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasNetwork() => $_has(2);
  @$pb.TagNumber(4)
  void clearNetwork() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get challenge => $_getN(3);
  @$pb.TagNumber(5)
  set challenge($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasChallenge() => $_has(3);
  @$pb.TagNumber(5)
  void clearChallenge() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get signature => $_getN(4);
  @$pb.TagNumber(6)
  set signature($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasSignature() => $_has(4);
  @$pb.TagNumber(6)
  void clearSignature() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get signerProto => $_getSZ(5);
  @$pb.TagNumber(7)
  set signerProto($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(7)
  $core.bool hasSignerProto() => $_has(5);
  @$pb.TagNumber(7)
  void clearSignerProto() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get initMsg => $_getN(6);
  @$pb.TagNumber(8)
  set initMsg($core.List<$core.int> v) { $_setBytes(6, v); }
  @$pb.TagNumber(8)
  $core.bool hasInitMsg() => $_has(6);
  @$pb.TagNumber(8)
  void clearInitMsg() => clearField(8);
}

class RegistrationResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RegistrationResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'scheduler'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceCert')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceKey')
    ..hasRequiredFields = false
  ;

  RegistrationResponse._() : super();
  factory RegistrationResponse({
    $core.String? deviceCert,
    $core.String? deviceKey,
  }) {
    final _result = create();
    if (deviceCert != null) {
      _result.deviceCert = deviceCert;
    }
    if (deviceKey != null) {
      _result.deviceKey = deviceKey;
    }
    return _result;
  }
  factory RegistrationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegistrationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegistrationResponse clone() => RegistrationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegistrationResponse copyWith(void Function(RegistrationResponse) updates) => super.copyWith((message) => updates(message as RegistrationResponse)) as RegistrationResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RegistrationResponse create() => RegistrationResponse._();
  RegistrationResponse createEmptyInstance() => create();
  static $pb.PbList<RegistrationResponse> createRepeated() => $pb.PbList<RegistrationResponse>();
  @$core.pragma('dart2js:noInline')
  static RegistrationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegistrationResponse>(create);
  static RegistrationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceCert => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceCert($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceCert() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceCert() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeviceKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceKey() => clearField(2);
}

class ScheduleRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ScheduleRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'scheduler'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeId', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ScheduleRequest._() : super();
  factory ScheduleRequest({
    $core.List<$core.int>? nodeId,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    return _result;
  }
  factory ScheduleRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScheduleRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScheduleRequest clone() => ScheduleRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScheduleRequest copyWith(void Function(ScheduleRequest) updates) => super.copyWith((message) => updates(message as ScheduleRequest)) as ScheduleRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScheduleRequest create() => ScheduleRequest._();
  ScheduleRequest createEmptyInstance() => create();
  static $pb.PbList<ScheduleRequest> createRepeated() => $pb.PbList<ScheduleRequest>();
  @$core.pragma('dart2js:noInline')
  static ScheduleRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScheduleRequest>(create);
  static ScheduleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get nodeId => $_getN(0);
  @$pb.TagNumber(1)
  set nodeId($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);
}

class NodeInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'NodeInfoRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'scheduler'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeId', $pb.PbFieldType.OY)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'wait')
    ..hasRequiredFields = false
  ;

  NodeInfoRequest._() : super();
  factory NodeInfoRequest({
    $core.List<$core.int>? nodeId,
    $core.bool? wait,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (wait != null) {
      _result.wait = wait;
    }
    return _result;
  }
  factory NodeInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NodeInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NodeInfoRequest clone() => NodeInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NodeInfoRequest copyWith(void Function(NodeInfoRequest) updates) => super.copyWith((message) => updates(message as NodeInfoRequest)) as NodeInfoRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NodeInfoRequest create() => NodeInfoRequest._();
  NodeInfoRequest createEmptyInstance() => create();
  static $pb.PbList<NodeInfoRequest> createRepeated() => $pb.PbList<NodeInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static NodeInfoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NodeInfoRequest>(create);
  static NodeInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get nodeId => $_getN(0);
  @$pb.TagNumber(1)
  set nodeId($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get wait => $_getBF(1);
  @$pb.TagNumber(2)
  set wait($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasWait() => $_has(1);
  @$pb.TagNumber(2)
  void clearWait() => clearField(2);
}

class NodeInfoResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'NodeInfoResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'scheduler'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeId', $pb.PbFieldType.OY)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'grpcUri')
    ..hasRequiredFields = false
  ;

  NodeInfoResponse._() : super();
  factory NodeInfoResponse({
    $core.List<$core.int>? nodeId,
    $core.String? grpcUri,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (grpcUri != null) {
      _result.grpcUri = grpcUri;
    }
    return _result;
  }
  factory NodeInfoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NodeInfoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NodeInfoResponse clone() => NodeInfoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NodeInfoResponse copyWith(void Function(NodeInfoResponse) updates) => super.copyWith((message) => updates(message as NodeInfoResponse)) as NodeInfoResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NodeInfoResponse create() => NodeInfoResponse._();
  NodeInfoResponse createEmptyInstance() => create();
  static $pb.PbList<NodeInfoResponse> createRepeated() => $pb.PbList<NodeInfoResponse>();
  @$core.pragma('dart2js:noInline')
  static NodeInfoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NodeInfoResponse>(create);
  static NodeInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get nodeId => $_getN(0);
  @$pb.TagNumber(1)
  set nodeId($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get grpcUri => $_getSZ(1);
  @$pb.TagNumber(2)
  set grpcUri($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGrpcUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearGrpcUri() => clearField(2);
}

class RecoveryRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RecoveryRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'scheduler'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'challenge', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signature', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeId', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  RecoveryRequest._() : super();
  factory RecoveryRequest({
    $core.List<$core.int>? challenge,
    $core.List<$core.int>? signature,
    $core.List<$core.int>? nodeId,
  }) {
    final _result = create();
    if (challenge != null) {
      _result.challenge = challenge;
    }
    if (signature != null) {
      _result.signature = signature;
    }
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    return _result;
  }
  factory RecoveryRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RecoveryRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RecoveryRequest clone() => RecoveryRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RecoveryRequest copyWith(void Function(RecoveryRequest) updates) => super.copyWith((message) => updates(message as RecoveryRequest)) as RecoveryRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RecoveryRequest create() => RecoveryRequest._();
  RecoveryRequest createEmptyInstance() => create();
  static $pb.PbList<RecoveryRequest> createRepeated() => $pb.PbList<RecoveryRequest>();
  @$core.pragma('dart2js:noInline')
  static RecoveryRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecoveryRequest>(create);
  static RecoveryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get challenge => $_getN(0);
  @$pb.TagNumber(1)
  set challenge($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChallenge() => $_has(0);
  @$pb.TagNumber(1)
  void clearChallenge() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get signature => $_getN(1);
  @$pb.TagNumber(2)
  set signature($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSignature() => $_has(1);
  @$pb.TagNumber(2)
  void clearSignature() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get nodeId => $_getN(2);
  @$pb.TagNumber(3)
  set nodeId($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNodeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearNodeId() => clearField(3);
}

class RecoveryResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RecoveryResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'scheduler'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceCert')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceKey')
    ..hasRequiredFields = false
  ;

  RecoveryResponse._() : super();
  factory RecoveryResponse({
    $core.String? deviceCert,
    $core.String? deviceKey,
  }) {
    final _result = create();
    if (deviceCert != null) {
      _result.deviceCert = deviceCert;
    }
    if (deviceKey != null) {
      _result.deviceKey = deviceKey;
    }
    return _result;
  }
  factory RecoveryResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RecoveryResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RecoveryResponse clone() => RecoveryResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RecoveryResponse copyWith(void Function(RecoveryResponse) updates) => super.copyWith((message) => updates(message as RecoveryResponse)) as RecoveryResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RecoveryResponse create() => RecoveryResponse._();
  RecoveryResponse createEmptyInstance() => create();
  static $pb.PbList<RecoveryResponse> createRepeated() => $pb.PbList<RecoveryResponse>();
  @$core.pragma('dart2js:noInline')
  static RecoveryResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecoveryResponse>(create);
  static RecoveryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceCert => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceCert($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceCert() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceCert() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeviceKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceKey() => clearField(2);
}

class UpgradeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpgradeRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'scheduler'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signerVersion')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'initmsg', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  UpgradeRequest._() : super();
  factory UpgradeRequest({
    $core.String? signerVersion,
    $core.List<$core.int>? initmsg,
  }) {
    final _result = create();
    if (signerVersion != null) {
      _result.signerVersion = signerVersion;
    }
    if (initmsg != null) {
      _result.initmsg = initmsg;
    }
    return _result;
  }
  factory UpgradeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpgradeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpgradeRequest clone() => UpgradeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpgradeRequest copyWith(void Function(UpgradeRequest) updates) => super.copyWith((message) => updates(message as UpgradeRequest)) as UpgradeRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpgradeRequest create() => UpgradeRequest._();
  UpgradeRequest createEmptyInstance() => create();
  static $pb.PbList<UpgradeRequest> createRepeated() => $pb.PbList<UpgradeRequest>();
  @$core.pragma('dart2js:noInline')
  static UpgradeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpgradeRequest>(create);
  static UpgradeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get signerVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set signerVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSignerVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignerVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get initmsg => $_getN(1);
  @$pb.TagNumber(2)
  set initmsg($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInitmsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearInitmsg() => clearField(2);
}

class UpgradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpgradeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'scheduler'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'oldVersion')
    ..hasRequiredFields = false
  ;

  UpgradeResponse._() : super();
  factory UpgradeResponse({
    $core.String? oldVersion,
  }) {
    final _result = create();
    if (oldVersion != null) {
      _result.oldVersion = oldVersion;
    }
    return _result;
  }
  factory UpgradeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpgradeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpgradeResponse clone() => UpgradeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpgradeResponse copyWith(void Function(UpgradeResponse) updates) => super.copyWith((message) => updates(message as UpgradeResponse)) as UpgradeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpgradeResponse create() => UpgradeResponse._();
  UpgradeResponse createEmptyInstance() => create();
  static $pb.PbList<UpgradeResponse> createRepeated() => $pb.PbList<UpgradeResponse>();
  @$core.pragma('dart2js:noInline')
  static UpgradeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpgradeResponse>(create);
  static UpgradeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get oldVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set oldVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOldVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearOldVersion() => clearField(1);
}

